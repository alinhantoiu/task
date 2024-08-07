data "aws_subnet" "public_subnets" {
  id = var.subnet_id
}

resource "aws_instance" "server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_id]

  # User data script
  user_data = <<-EOF
              #!/bin/bash
              # Disable ufw
                systemctl disable ufw 
                systemctl stop ufw 
              # Install k3s
                curl -sfL https://get.k3s.io | sh -
              # You can add more commands here
              EOF

  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
  }

  tags = {
    Name = "terraform-ec2-${terraform.workspace}"
  }
}