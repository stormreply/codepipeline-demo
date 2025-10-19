# EventBridge rule to trigger CodePipeline on GitHub push events
resource "aws_cloudwatch_event_rule" "github_push" {
  name        = "${local._name_tag}-github-push"
  description = "Trigger CodePipeline on GitHub push to /app folder"

  event_pattern = jsonencode({
    source      = ["aws.codeconnections"]
    detail-type = ["CodeStar Source Connection State Change"]
    detail = {
      event          = ["referenceCreated", "referenceUpdated"]
      referenceType  = ["branch"]
      referenceName  = ["main"]
      connectionArn  = [aws_codestarconnections_connection.github.arn]
      repositoryName = ["${var.github_owner}/${var.github_repo}"]
      # Note: Path filtering is not directly supported in CodeStar events
      # The pipeline will need to check changed files in buildspec
    }
  })
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule     = aws_cloudwatch_event_rule.github_push.name
  arn      = aws_codepipeline.pipeline.arn
  role_arn = aws_iam_role.eventbridge_codepipeline.arn
}

# IAM role for EventBridge to trigger CodePipeline
resource "aws_iam_role" "eventbridge_codepipeline" {
  name = "${local._name_tag}-eventbridge-codepipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_codepipeline" {
  name = "${local._name_tag}-eventbridge-codepipeline"
  role = aws_iam_role.eventbridge_codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codepipeline:StartPipelineExecution"
        ]
        Resource = aws_codepipeline.pipeline.arn
      }
    ]
  })
}
