// creating ssh-key in aws 

resource "aws_key_pair" "ec2-tf-test-key" {
  key_name   = "terraform-test-key"
  public_key = file("${path.module}/id_rsa.pub")
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  dynamic "ingress" {
    for_each = [22, 80,443]
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
    
      from_port   = 0
      to_port     = 0
      protocol    = "-1" // meas all 
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    
  }



} 




# ingress {

#     description = "security-group-1"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

# ingress {

#     description = "security-group-1"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

# ingress {

#     description = "security-group-1"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }






resource "aws_instance" "web" {

  ami             = "ami-08ee1453725d19cdb"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.ec2-tf-test-key.key_name}"
  vpc_security_group_ids  = [aws_security_group.allow_tls.id]
  tags = {
    Name = "first-terraform-instance"
  }


 }
























