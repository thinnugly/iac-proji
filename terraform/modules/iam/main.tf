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

# --- POLÍTICAS GERENCIADAS (AWS MANAGED) ---

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# --- POLÍTICA INLINE CUSTOMIZADA PARA O ANSIBLE/PIPELINE ---

resource "aws_iam_role_policy" "ssm_ansible_execution" {
  name = "ssm_ansible_execution"
  role = aws_iam_role.ec2_assume_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "ssm:CancelCommand"
        ]
        Resource = "*"
    }]
  })
}

# --- INSTANCE PROFILE ---

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = var.iam_instance_profile
  role = aws_iam_role.ec2_assume_role.name
}