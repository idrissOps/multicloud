# Configuration du provider AWS


provider "aws" {
  region = "us-east-1"

}

# Création d'un groupe de sécurité
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [""]
  }
}

# Création d'une instance EC2 sur aws

resource "aws_instance" "example" {
  ami           = "" 
  instance_type = "t2.micro"

  tags = {
    Name = "EC2 Instance 1"
  }

  security_groups = [aws_security_group.allow_ssh.id]
}