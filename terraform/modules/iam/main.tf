resource "aws_iam_role" "ec2_assume_role" {
  name = var.role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowEC2AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# =========================================================
# AWS MANAGED POLICIES
# =========================================================

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# =========================================================
# POLICY: ANSIBLE + SSM EXECUTION
# =========================================================

resource "aws_iam_policy" "ssm_ansible_execution" {
  name        = var.ansible_policy
  description = "Permite execucao do Ansible via SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations",
          "ssm:CancelCommand"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_ansible" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = aws_iam_policy.ssm_ansible_execution.arn
}

# =========================================================
# POLICY: S3 ACCESS FOR ANSIBLE SSM
# =========================================================

resource "aws_iam_policy" "ssm_s3_access" {
  name        = var.s3_policy
  description = "Permite ao SSM usar bucket S3 temporario"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::s3-ansible-proji/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::s3-ansible-proji"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_s3_attach" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = aws_iam_policy.ssm_s3_access.arn
}

# =========================================================
# INSTANCE PROFILE
# =========================================================

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = var.iam_instance_profile
  role = aws_iam_role.ec2_assume_role.name
}