output "ec2_public_ip" {
  value = aws_instance.taskflow_ec2.public_ip
}
