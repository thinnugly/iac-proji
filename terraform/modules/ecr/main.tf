resource "aws_ecr_repository" "ecr_repository" {
  name = var.repository_name
  image_tag_mutability = var.image_tag_mutability
}