{
  "variables": {
    "region": "us-east-1",
    "tag":    "kali",
    "root_volume_size_Gi": "120"
  },
  "builders": [{
    "ami_description": "Encrypted - Kali AMI",
    "ami_name": "Encrypted-Kali-{{isotime | clean_resource_name}}",
    "instance_type": "t2.medium",
    "region": "{{user `region`}}",
    "encrypt_boot": "true",
    "source_ami_filter": {
      "filters": {
        "architecture": "x86_64",
        "block-device-mapping.volume-type": "gp2",
        "name": "kali-last*",
        "root-device-type": "ebs",
        "virtualization-type": "hvm"
      },
      "most_recent": true,
      "owners": [
        "679593333241"
      ]
    },
    "launch_block_device_mappings": [
      {
        "device_name": "/dev/sda1",
        "volume_size": "{{user `root_volume_size_Gi`}}",
        "volume_type": "gp2",
        "encrypted": true,
        "delete_on_termination": true
      }
    ],
    "run_tags":{
      "Name":"{{user `tag`}}"
    },
    "ssh_username": "kali",
    "type": "amazon-ebs"
  }],
  "provisioners": [{
    "inline": [
      "echo set debconf to Noninteractive",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "echo 'Sleeping for 30 seconds to give Kali enough time to initialize (otherwise, packages may fail to install!)'",
      "sleep 30",
      "sudo apt-get update",
      "echo 'BASHRC/ZSH Profile INIT!'",
      "touch ~/.bash_profile",
      "echo \"if [ -f ~/.bashrc ]; then\" > ~/.bash_profile",
      "echo \"  . ~/.bashrc\" >> ~/.bash_profile",
      "echo \"fi\" >> ~/.bash_profile",
      "echo",
      "touch ~/.zshrc",
      "echo \"if [ -f ~/.~/.zshrc ]; then\" > ~/.zshrc",
      "echo \"  . ~/.~/.zshrc\" >> ~/.zshrc",
      "echo \"fi\" >> ~/.zshrc"
    ],
    "type": "shell"
  },

    {
      "type": "file",
      "source": "{{template_dir}}/ssh/kali-key.pub",
      "destination": "/home/kali/.ssh/authorized_keys"
    }
  ]
}
