resource "aws_default_subnet" "default" {
  for_each          = toset(local.availability_zones.names)
  availability_zone = each.value
  tags = {
    Name = "Default subnet for ${each.value}"
  }
}
