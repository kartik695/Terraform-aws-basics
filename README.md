# Terraform-aws-basics

Terraform configuration-> suppose you and your friend are having 2 different version of terraform and you are using its terraform configuration code so version might clash
and we provide terraform configuration

and also provide version of aws so that it can get latest providors
terraform {
    required_version = "1.9.5"
 required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "2.43.0"
    }
}

}


terraform configuration file which is described above do not use variables it takes only hard coded values


