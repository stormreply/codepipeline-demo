# codepipeline-demo

A demo of AWS codepipeline, using github, codebuild and codedeploy

#### Storm Library for Terraform

This repository is a member of the SLT | Storm Library for Terraform,
a collection of Terraform modules for Amazon Web Services. The focus
of these modules, maintained in separate GitHub™ repositories, is on
building examples, demos and showcases on AWS. The audience of the
library is learners and presenters alike - people that want to know
or show how a certain service, pattern or solution looks like, or "feels".

[Learn more](https://github.com/stormreply/storm-library-for-terraform)

## Installation

This demo can be built using GitHub Actions. In order to do so

- [Install the Storm Library for Terraform](https://github.com/stormreply/storm-library-for-terraform/blob/main/docs/INSTALL-LIBRARY.md)
- [Deploy this member repository](https://github.com/stormreply/storm-library-for-terraform/blob/main/docs/DEPLOY-MEMBER.md)

Deployment of this member will take 4-5 minutes on GitHub resources.

## Architecture

[Image]

## Explore this demo

Follow these steps in order to explore this demo:

1. Developer Tools -> Settings -> Connections: select slt github connection, click "Update Pending Connection"
1. In the pipeline, re-run the failed Source action, which will trigger the whole pipeline
1. Note that it will be stuck in the Approval stage. Click "Manual Approval", approve and optionally enter a comment
1. Wait for the pipeline to finish
1. In the Deploy state, click on "Amazon ECS"
1. In the ECS view, click on the Load Balancer
1. In the Load Balancer view, copy the DNS name
1. Use the DNS name in the input of a new tab. NOTE: prefix http://, do NOT use the default https://
1. You will see the application page. It's containing info about the Container IP and the Commit SHA from which it was built.
   Countercheck the Commit SHA


## Terraform Docs

<details>
<summary>Click to show</summary>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.build](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codepipeline.pipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarconnections_connection.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_default_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_subnet) | resource |
| [aws_default_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.codebuild_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codebuild_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codebuild_s3_artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline_codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline_codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.codepipeline_s3_artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ecs_task_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.aws_codebuild_developer_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aws_codepipeline_fullaccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_s3_bucket.artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ecs_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecs_task_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input__metadata"></a> [\_metadata](#input\_\_metadata) | Select metadata passed from GitHub Workflows | <pre>object({<br/>    actor      = string # Github actor (deployer) of the deployment<br/>    catalog_id = string # SLT catalog id of this module<br/>    deployment = string # slt-<catalod_id>-<repo>-<actor><br/>    ref        = string # Git reference of the deployment<br/>    ref_name   = string # Git ref_name (branch) of the deployment<br/>    repo       = string # GitHub short repository name (without owner) of the deployment<br/>    repository = string # GitHub full repository name (including owner) of the deployment<br/>    sha        = string # Git (full-length, 40 char) commit SHA of the deployment<br/>    short_name = string # slt-<catalog_id>-<actor><br/>    time       = string # Timestamp of the deployment<br/>  })</pre> | <pre>{<br/>  "actor": "",<br/>  "catalog_id": "",<br/>  "deployment": "",<br/>  "ref": "",<br/>  "ref_name": "",<br/>  "repo": "",<br/>  "repository": "",<br/>  "sha": "",<br/>  "short_name": "",<br/>  "time": ""<br/>}</pre> | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | n/a | `string` | `"stormreply"` | no |
| <a name="input_github_repo"></a> [github\_repo](#input\_github\_repo) | n/a | `string` | `"codepipeline-demo"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output__slt_config"></a> [\_slt\_config](#output\_\_slt\_config) | Map of SLT configuration |
| <a name="output_load_balancer_dns_name"></a> [load\_balancer\_dns\_name](#output\_load\_balancer\_dns\_name) | DNS name of the Application Load Balancer |
| <a name="output_load_balancer_url"></a> [load\_balancer\_url](#output\_load\_balancer\_url) | URL of the Application Load Balancer |
<!-- END_TF_DOCS -->

</details>

## Credits

- [...]
