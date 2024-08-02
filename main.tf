terraform {
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

#new aws instance
provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "Sam_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "SamInstance"
  }
}

