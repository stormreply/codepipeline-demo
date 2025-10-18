resource "aws_codebuild_project" "build" {
  name         = local._name_tag
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE" # | NO_ARTIFACTS | S3, cf. https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-codebuild-project-artifacts.html
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"       # up to 4 GiB memory and 2 vCPUs for builds
    image        = "aws/codebuild/standard:7.0" # based on Ubuntu 22 with MLS
    type         = "LINUX_CONTAINER"            # cf. https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = local.account_id
    }
    environment_variable {
      name  = "AWS_REGION"
      value = local.region
    }
    environment_variable {
      name  = "ECR_REPO_NAME"
      value = local.ecr_repository_name
    }
  }

  source {
    # source code settings are specified in the source action of the pipeline in CodePipeline
    # cf. https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-codebuild-project-source.html
    type      = "CODEPIPELINE"
    buildspec = file("${path.module}/buildspec.yml")
  }
}

resource "aws_iam_role" "codebuild" {
  name = "${local._name_tag}-codebuild"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_codebuild_developer_access" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}
