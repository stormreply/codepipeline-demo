resource "aws_ecs_task_definition" "task" {
  family                   = "demo-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "app"
      image = "${aws_ecr_repository.repo.repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
  execution_role_arn = aws_iam_role.ecs_task_exec.arn
}

# --- IAM Role for ECS Task Execution ---
data "aws_iam_policy_document" "ecs_task_exec" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:ListImages",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_task_exec" {
  name = local._name_tag # "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Effect    = "Allow"
    }]
  })
}

resource "aws_iam_role_policy" "ecs_task_exec" {
  role   = aws_iam_role.ecs_task_exec.id
  policy = data.aws_iam_policy_document.ecs_task_exec.json
}
