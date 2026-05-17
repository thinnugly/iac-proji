module "iam" {
  source               = "../../modules/iam"
  role                 = var.role
  iam_instance_profile = var.iam_instance_profile
}

module "security_group" {
  source         = "../../modules/security-group"
  security_group = var.security_group
  vpc_id         = var.vpc_id
}

module "ecr" {
  source               = "../../modules/ecr"
  repository_name      = var.repository_name
  image_tag_mutability = var.image_tag_mutability
}

module "ec2" {
  source               = "../../modules/ec2"
  instance_count       = var.instance_count
  ami                  = var.ami
  instance_type        = var.instance_type
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = module.iam.iam_instance_profile
  ec2_role             = var.ec2_role
}