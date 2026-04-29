resource "aws_instance" "ec2" {
  count = var.instance_count
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile = var.iam_instance_profile

  tags = {
    Name = "proji-${count.index + 1}"
    Role = var.ec2_role
  }
}