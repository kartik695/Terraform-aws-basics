// creating ssh-key in aws 

resource "aws_key_pair" "ec2-tf-test-key" {
  key_name   = "terraform-test-key"
  public_key = file("${path.module}/id_rsa.pub")
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      description = "terraform-security-group"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress { // egress-> outbound rule whereas ingress stand for inbound rule

    from_port        = 0
    to_port          = 0
    protocol         = "-1" // meas all 
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

}



resource "aws_instance" "web" {

  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2-tf-test-key.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags = {
    Name = "first-terraform-instance"
  }
  // command to execute while creating ec2 instance
  user_data = <<EOF
#!/bin/bash
sudo yum update
sudo  amazon-linux-extras install nginx1
systemctl start nginx
systemctl enable nginx
EOF


  // file provisoners used for mange the files for remote source
  provisioner "file" {
    source      = "../README.md"   // path of terraform machine
    destination = "/tmp/readme.md" // path of remote machine

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/id_rsa")
      host        = self.public_ip // so that infinite loop do not happen

    }
  }



  // local-exec provisoners -> these are used to execute local commands on machine where terraform is running

  // provisoners contains many things like working_dir and command

  // ok when you  run provisoners  it runs by deafult
  provisioner "local-exec" {
    command     = "echo command will be executed on start" // it will execute on my local machine
  }

  // Remember provisoners are applied to only that resource in which they comes under
  provisioner "local-exec" {
    when        = destroy // when we run terraform destroy it will run (Remember provisoner will run and then resource will be destroy)
    working_dir = "/tmp/"
    command     = "echo ${self.public_ip} > mypublic.txt" // it will execute on my local machine
  }


// Remember if provisoner gets failed it mark terraform resource as taint-. which means if you apply terraform command next time whole resources will be craeted from scratch



provisioner "remote-exec" { // remote exec run command or script on remote server 
    // inline -> used to provide list of command strings
    inline = [ 
     

     ]
  }
provisioner "remote-exec" { // remote exec run command or script on remote server 
  // used to execute script and if you  want to execute scripts and use scripts block 
  script = ""
   


  }





}





// creating instance through modules

# module "mywebserver" {
#   source = "../../Terraform-Module/webserver"
#   image_id = "hjsgcdhjsgcgs"
#   instance_type = "t2.small"
#   # key = file("${path.module}/id_rsa.pub")
# }


  










