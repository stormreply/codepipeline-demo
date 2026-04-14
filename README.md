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
<!-- END_TF_DOCS -->

</details>

## Credits

- [...]
