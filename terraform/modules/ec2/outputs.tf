output "ec2_instances" {
  value = {
    for i in aws_instance.ec2 : 
    i.ids => {
        public_ip = i.public_ip
        name = i.tags["Name"]
    }
  }
}