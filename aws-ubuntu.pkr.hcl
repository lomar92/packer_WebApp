packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioners and post-processors on a
# source.

source "amazon-ebs" "eu-central-1" {
  ami_name      = "packer-DogWebapp-aws"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

#source "amazon-ebs" "eu-west-1" {
#  ami_name      = "packer-DogWebapp-aws"
#  instance_type = "t2.micro"
#  region        = "eu-west-1"
  
#  source_ami_filter {
#    filters = {
#      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
#      root-device-type    = "ebs"
#      virtualization-type = "hvm"
#    }
#    most_recent = true
#    owners      = ["099720109477"]
#  }
#  ssh_username = "ubuntu"
#}

build {
  name = "learn-packer"
  sources = [
  "source.amazon-ebs.eu-central-1"
]

provisioner "file" {
    source      = "./tf-packer.pub"
    destination = "/tmp/tf-packer.pub"
  }

provisioner "file" {
    source      = "file/"
    destination = "/home/ubuntu/"
  }
  provisioner "shell" {
    inline = [
      "sudo apt -y update",
      "sleep 15",
      "sudo apt -y update",
      "sudo apt -y install apache2",
      "sudo systemctl start apache2",
      "sudo chown -R ubuntu:ubuntu /var/www/html",
      "chmod +x *.sh",
      "./deploy_app.sh",
      "sudo apt -y install cowsay",
      "cowsay -f tux I am not a Dog!",
    ]
  }
}
