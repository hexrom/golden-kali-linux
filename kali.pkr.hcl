variable "region" {
  default = "us-east-1"
}

variable "tag" {
  default = "kali"
}

variable "root_volume_size_Gi" {
  default = "75"
}

source "amazon-ebs" "kali-linux" {
  ami_description            = "Encrypted - Kali AMI"
  ami_name                   = "Encrypted-Kali-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  instance_type              = "t2.medium"
  region                     = var.region
  encrypt_boot               = true
  source_ami_filter {
    filters = {
      "architecture"                = "x86_64"
      "block-device-mapping.volume-type" = "gp2"
      "name"                        = "kali-last*"
      "root-device-type"            = "ebs"
      "virtualization-type"         = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = var.root_volume_size_Gi
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  run_tags {
    Name = var.tag
  }
  ssh_username = "kali"
}

build {
  sources = [
    "source.amazon-ebs.kali-linux"
  ]

  provisioner "shell" {
    inline = [
      "echo set debconf to Noninteractive",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "echo 'Sleeping for 30 seconds to give Kali enough time to initialize (otherwise, packages may fail to install!)'",
      "sleep 30",
      "sudo apt-get update",
      "echo 'BASHRC/ZSH Profile INIT!'",
      "touch ~/.bash_profile",
      "echo 'if [ -f ~/.bashrc ]; then' > ~/.bash_profile",
      "echo '  . ~/.bashrc' >> ~/.bash_profile",
      "echo 'fi' >> ~/.bash_profile",
      "echo",
      "touch ~/.zshrc",
      "echo 'if [ -f ~/.~/.zshrc ]; then' > ~/.zshrc",
      "echo '  . ~/.~/.zshrc' >> ~/.zshrc",
      "echo 'fi' >> ~/.zshrc"
    ]
  }

  provisioner "file" {
    source      = "${path.root}/ssh/kali-key.pub"
    destination = "/home/kali/.ssh/authorized_keys"
  }
}

