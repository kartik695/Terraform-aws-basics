Terraform workspaces provide a way to manage multiple environments or instances of your infrastructure within the same configuration



After creating environment,switch to different environments and apply terraform apply --auto-approve --var-file=dev-terraform.tfvars
In this way it  appled to dev environment where it maintains its own tf state file 



