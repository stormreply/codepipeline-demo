resource "aws_codestarconnections_connection" "github" {
  name          = "${local._metadata.short_name}-github"
  provider_type = "GitHub" # cf. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection#provider_type-3
}

# Add the necessary IAM permissions for CodePipeline to use CodeStar Connections
resource "aws_iam_role_policy" "codepipeline_codestar" {
  name = "${local._name_tag}-codestar"
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
