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
    environment_variable {
      name  = "APP_NAME"
      value = local._name_tag
    }
  }

  source {
    # source code settings are specified in the source action of the pipeline in CodePipeline
    # cf. https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-properties-codebuild-project-source.html
    type = "CODEPIPELINE"
    # Use buildspec.yml from the source repository instead of embedding it
    # This allows buildspec changes without terraform apply
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

resource "aws_iam_role_policy" "codebuild_logs" {
  name = "${local._name_tag}-codebuild-logs"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${local._name_tag}",
          "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/codebuild/${local._name_tag}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_s3_artifacts" {
  name = "${local._name_tag}-codebuild-s3-artifacts"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.artifacts.arn,
          "${aws_s3_bucket.artifacts.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_ecr" {
  name = "${local._name_tag}-codebuild-ecr"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "arn:aws:ecr:${local.region}:${local.account_id}:repository/${local.ecr_repository_name}"
      }
    ]
  })
}
