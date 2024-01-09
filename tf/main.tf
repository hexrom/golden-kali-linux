provider "aws" {
  region = var.region
}

resource "aws_instance" "kali_linux" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Kali"
  }
}

