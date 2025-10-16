resource "aws_codestarconnections_connection" "github" {
  name          = "github-connection"
  provider_type = "GitHub"
}

# Add the necessary IAM permissions for CodePipeline to use CodeStar Connections
resource "aws_iam_role_policy" "codepipeline_codestar" {
  name = "codepipeline-codestar-policy"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:UseConnection"
        ]
        Resource = aws_codestarconnections_connection.github.arn
      }
    ]
  })
}
