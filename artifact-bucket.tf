resource "aws_s3_bucket" "artifacts" {

  bucket        = "${local._name_tag}-artifacts"
  force_destroy = true
}
