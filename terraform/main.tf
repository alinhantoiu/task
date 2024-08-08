module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source                     = "./modules/ec2"
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  subnet_id                  = element(module.vpc.public_subnet_id, 0)
  security_group_id          = module.sg.sg_id
}

module "helm" {
  source = "./modules/helm"
  depends_on = [module.ec2]
}