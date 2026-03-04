---
title: "Deployment"
chapter: false
menuTitle: "Deployment"
weight: 30
---

Once the prerequisites have been satisfied proceed with the deployment steps below.

1.  Clone this repo with the command below.
```
git clone https://github.com/FortinetCloudCSE/fortigate-aws-cwanconnect-ha-dualaz-terraform.git
```

2.  Change directories and modify the terraform.tfvars file with your credentials and deployment information. 

{{% notice note %}} In the terraform.tfvars file, the comments explain what inputs are expected for the variables. For further details on a given variable or to see all possible variables, reference the variables.tf file. {{% /notice %}}
```
cd fortigate-aws-cwanconnect-ha-dualaz-terraform/terraform
nano terraform.tfvars
```

3.  When ready to deploy, use the commands below to run through the deployment.
```
terraform init
terraform validate
terraform apply --auto-approve
```

4.  When the deployment is complete, you will see login information for the FortiGates like so.
```
Apply complete! Resources: 58 added, 0 changed, 0 destroyed.

Outputs:

cwan_existing = ""
cwan_new = <<EOT
# cwan id: core-network-08eaa2d4e8eb4f00b
# cwan arn: arn:aws:networkmanager::980933617837:core-network/core-network-08eaa2d4e8eb4f00b
# cwan segment key: segment
# cwan segment values = inspection, production, development

EOT
fgt_login_info = <<EOT
# fgt username: admin
# fgt initial password: i-0c728336acddbeec2
# cluster login url: https://34.234.189.5
# fgt1 login url: https://52.203.26.251
# fgt2 login url: https://184.73.179.20

EOT
```