resource "aws_iam_role" "ec2_assume_role" {
  name = var.role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Sid = "AllowEC2AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role = aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = var.iam_instance_profile
  role = aws_iam_role.ec2_assume_role.name
}