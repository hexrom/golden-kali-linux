{
  "variables": {
    "ami"   : "{{env `AMI`}}",
    "region": "{{env `REGION`}}",
    "script": "{{env `SCRIPT`}}",
    "tag":    "{{env `NAME`}}",
    "root_volume_size_Gi": "120"
  },
  "builders": [{
    "ami_description": "Encrypted - Kali AMI",
    "ami_name": "Encrypted-{{user `ami`}}-{{isotime | clean_resource_name}}",
    "instance_type": "t3.2xlarge",
    "region": "{{user `region`}}",
    "encrypt_boot": "true",
    "source_ami_filter": {
      "filters": {
        "architecture": "x86_64",
        "block-device-mapping.volume-type": "gp2",
        "name": "kali-linux-2022.3b-804fcc46-63fc-4eb6-85a1-50e66d6c7215",
        "root-device-type": "ebs",
        "virtualization-type": "hvm"
      },
      "most_recent": true,
      "owners": [
        "211372476111"
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
      "scripts": [
        "{{template_dir}}/{{user `script`}}"
      ],
      "type": "shell"
    },
    {
      "type": "file",
      "source": "{{template_dir}}/desktop/install-tools.sh",
      "destination": "/home/kali/install-tools.sh"
    },
    {
      "type": "file",
      "source": "{{template_dir}}/desktop/motd.sh",
      "destination": "/home/kali/motd.sh"
    },
    {
      "type": "file",
      "source": "{{template_dir}}/desktop/domains/orig.domains.txt",
      "destination": "/home/kali/domains/orig.domains.txt"
    },
    {
      "type": "file",
      "source": "{{template_dir}}/desktop/domains/asset_note.domains.txt",
      "destination": "/home/kali/domains/asset_note.txt"
    },
    {
      "type": "file",
      "source": "/path/to/your/ssh/public/key.pub",
      "destination": "/home/kali/.ssh/authorized_keys"
    }
  ]
}
