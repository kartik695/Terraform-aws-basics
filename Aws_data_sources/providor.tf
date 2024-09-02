
provider "aws" {
  region     = ""
  access_key = ""
  secret_key = ""

}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["137112412989"]


  filter {
    name   = "name"
    values = "amazon/amzn2-ami-kernel-5.10-hvm-2.0.20240816.0-x86_64-gp2"
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }





}










