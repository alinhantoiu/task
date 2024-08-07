variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-04a81a99f5ec58529"
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the instance"
  type        = string
}