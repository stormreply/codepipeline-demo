data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id          = data.aws_caller_identity.current.account_id
  ecr_repository_name = local._deployment
  region              = data.aws_region.current.region
}
