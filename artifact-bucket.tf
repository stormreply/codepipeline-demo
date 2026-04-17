resource "aws_s3_bucket" "artifacts" {

  bucket        = "${local._deployment}-artifacts"
  force_destroy = true
}
