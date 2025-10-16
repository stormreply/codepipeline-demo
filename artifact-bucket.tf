resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "ecs-demo-artifacts-"
  force_destroy = true
}
