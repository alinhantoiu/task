# Retrieve vpc id created in vpc module
data "aws_vpc" "main" {
  id = var.vpc_id
}

# Create a security group 

resource "aws_security_group" "sg_tf" {
 name        = "sg_tf"
 description = "Allow SSH to server"
 vpc_id      = data.aws_vpc.main.id

 tags = {
   Name = "terraform-sg-${terraform.workspace}"
 }
}

# Create security group rules 

resource "aws_security_group_rule" "allow_ssh" {
 type              = "ingress"
 description       = "SSH"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.sg_tf.id
}

resource "aws_security_group_rule" "allow_http_outbound" {
 type              = "egress"
 description       = "HTTP"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.sg_tf.id
}

resource "aws_security_group_rule" "allow_https_outbound" {
 type              = "egress"
 description       = "HTTP"
 from_port         = 443
 to_port           = 443
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.sg_tf.id
}