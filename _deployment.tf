variable "deployment" {
  type = object({
    actor       = string # Github actor (deployer) of the deployment
    environment = string # environment of the deployment
    name        = string # name of the deployment
    ref         = string # Git reference of the deployment
    ref_name    = string # Git ref_name (branch) of the deployment
    repo        = string # GitHub short repository name (without owner) of the deployment
    repository  = string # GitHub full repository name (including owner) of the deployment
    sha         = string # Git (full-length, 40 char) commit SHA of the deployment
    time        = string # Timestamp of the deployment
  })
}

output "deployment" {
  value = var.deployment
}
