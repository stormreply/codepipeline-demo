# EventBridge rule to trigger pipeline on CodeStar connection events
resource "aws_cloudwatch_event_rule" "codepipeline_trigger" {
  name        = "${local._name_tag}-pipeline-trigger"
  description = "Trigger pipeline on GitHub push to main branch"

  event_pattern = jsonencode({
    source      = ["aws.codeconnections"]
    detail-type = ["CodeConnections Source Action State Change"]
    resources   = [aws_codestarconnections_connection.github.arn]
    detail = {
      event = ["referenceCreated", "referenceUpdated"]
      referenceName = ["main"]
    }
  })
}

resource "aws_cloudwatch_event_target" "codepipeline" {
  rule      = aws_cloudwatch_event_rule.codepipeline_trigger.name
  target_id = "TriggerPipeline"
  arn       = aws_codepipeline.pipeline.arn
  role_arn  = aws_iam_role.eventbridge_pipeline.arn
}

# IAM role for EventBridge to start pipeline
resource "aws_iam_role" "eventbridge_pipeline" {
  name = "${local._name_tag}-eventbridge-pipeline"

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

resource "aws_iam_role_policy" "eventbridge_pipeline" {
  name = "${local._name_tag}-eventbridge-pipeline"
  role = aws_iam_role.eventbridge_pipeline.id

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
