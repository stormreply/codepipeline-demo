# ------------------------------------------------------------
# 1. ECR Repository
# ------------------------------------------------------------
resource "aws_ecr_repository" "app" {
  name = "ecs-app"
}

# ------------------------------------------------------------
# 2. ECS Cluster & Task Definition
# ------------------------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "ecs-codedeploy-demo"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ecs-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${aws_ecr_repository.app.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ------------------------------------------------------------
# 3. ECS Service mit Load Balancer (für Blue/Green)
# ------------------------------------------------------------
resource "aws_lb" "app" {
  name               = "ecs-codedeploy-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [var.lb_sg]
}

resource "aws_lb_target_group" "blue" {
  name        = "ecs-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "green" {
  name        = "ecs-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_ecs_service" "app" {
  name            = "ecs-app"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ecs_sg]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = "app"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}

# ------------------------------------------------------------
# 4. CodeDeploy Application & Deployment Group
# ------------------------------------------------------------
resource "aws_codedeploy_app" "ecs" {
  compute_platform = "ECS"
  name             = "ecs-codedeploy-app"
}

resource "aws_codedeploy_deployment_group" "ecs" {
  app_name              = aws_codedeploy_app.ecs.name
  deployment_group_name = "ecs-codedeploy-dg"
  service_role_arn      = var.codedeploy_role_arn

  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.app.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arn = aws_lb_listener.app.arn
      }
      target_group {
        name = aws_lb_target_group.blue.name
      }
      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}

# ------------------------------------------------------------
# 5. CodePipeline (GitHub → CodeBuild → CodeDeploy)
# ------------------------------------------------------------
resource "aws_codepipeline" "app" {
  name     = "ecs-codedeploy-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.pipeline_bucket
  }

  stage {
    name = "Source"
    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["build"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.app.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build"]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.ecs.name
        DeploymentGroupName = aws_codedeploy_deployment_group.ecs.deployment_group_name
      }
    }
  }
}

# ------------------------------------------------------------
# 6. CodeBuild Project
# ------------------------------------------------------------
resource "aws_codebuild_project" "app" {
  name         = "ecs-codedeploy-build"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:6.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec.yml")
  }
}
