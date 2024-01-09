output "instance_public_ip" {
  value = aws_instance.kali_linux.public_ip
  description = "The public IP address of the EC2 Kali Linux instance"
}
