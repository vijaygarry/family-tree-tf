// Root module that ties all infrastructure pieces together using modules

module "vpc" {
  source           = "./modules/vpc"
  vpc_cidr         = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone = var.availability_zone
}

module "security" {
  source       = "./modules/security"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = [module.vpc.public_subnet_id]
  https_port   = var.https_port
  allowed_ssh_ip = var.allowed_ssh_ip
}

module "ec2" {
  source          = "./modules/ec2"
  subnet_id       = module.vpc.public_subnet_id
  security_groups = [module.security.sg_id]
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  user_data_file  = var.user_data_file
  ssh_key_file_path = var.ssh_key_file_path
}
