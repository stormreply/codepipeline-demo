data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available
}
