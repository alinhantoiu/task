data "aws_subnet" "private_subnets" {
  id = var.subnet_id
}

resource "aws_instance" "server" {
  ami            = var.ami_id
  instance_type  = var.instance_type
  subnet_id      = var.subnet_id
  #security_group = var.security_group_id

  tags = {
    Name = "terraform-ec2-${terraform.workspace}"
  }
}