data "aws_subnet" "public_subnets" {
  id = var.subnet_id
}

resource "tls_private_key" "ubuntu" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ubuntu.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ubuntu.private_key_pem
  filename = "${path.module}/private_key.pem"
  file_permission = "0600"

  depends_on = [
    tls_private_key.ubuntu,
    aws_key_pair.generated_key
  ]
}

resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = [var.security_group_id]
  associate_public_ip_address = "true"
  key_name                    = aws_key_pair.generated_key.key_name 

  # User data script
  user_data = <<-EOF
              #!/bin/bash
              # Disable ufw
                systemctl disable ufw 
                systemctl stop ufw 

              # Install k3s
                curl -sfL https://get.k3s.io | PUBLIC_IP=$(curl http://checkip.amazonaws.com) INSTALL_K3S_EXEC="--tls-san $PUBLIC_IP" sh -s -

              # Copy k3s.yaml kube config to /tmp
                sudo cp /etc/rancher/k3s/k3s.yaml /tmp/k3s.yaml
                sudo chmod 644 /tmp/k3s.yaml

              # Replace private ip with public ip in k3s.yaml config
                sudo sed -i "s/127.0.0.1/$(curl -s http://checkip.amazonaws.com)/g" /tmp/k3s.yaml
              EOF

  root_block_device {
    volume_size           = 30
    volume_type           = "gp2"
  }

  tags = {
    Name = "terraform-ec2-${terraform.workspace}"
  }
}

resource "null_resource" "scp" {

  triggers = {
    always_run = "${timestamp()}"
  }
  
  provisioner "local-exec" {
    command = "sleep 60 && scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${local_file.private_key.filename} ubuntu@${aws_instance.server.public_ip}:/tmp/k3s.yaml ./k3s.yaml"
  }
  depends_on = [aws_instance.server]
}

resource "null_resource" "cleanup" {
  provisioner "local-exec" {
    command = "rm -f ${local_file.private_key.filename}"
  }
  depends_on = [null_resource.scp]
}