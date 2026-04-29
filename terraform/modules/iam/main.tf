data "aws_iam_role" "ec2_assume_role" {
  name = var.role
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role = data.aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role = data.aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = var.iam_instance_profile
  role = data.aws_iam_role.ec2_assume_role.name
}