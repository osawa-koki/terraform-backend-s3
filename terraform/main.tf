
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    region  = "ap-northeast-1"
  }
}

variable "backend_bucket_name" {
  type = string
  description = "Name of the S3 bucket to store the Terraform state file."
}

variable "project_name" {
  type = string
  default = "simple-ec2-instance"
  description = "Name of the project."
}

variable "ssh_public_key_path" {
  type = string
  default = "~/.ssh/id_rsa.pub"
  description = "Path to the public key."
}

variable "allowed_ip_addresses" {
  type = list(string)
  description = "IP addresses allowed to access the instance."
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "example" {
  name = "${var.project_name}-security-group"
  vpc_id = aws_vpc.example.id
  ingress {
    description      = "SSH connection"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [for ip in var.allowed_ip_addresses: "${ip}/32"]
  }
  ingress {
    description      = "HTTP connection"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTPS connection"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    "name" = "${var.project_name}-security-group"
  }
}

resource "aws_key_pair" "example" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "example" {
  ami = "ami-be4a24d9"
  instance_type = "t2.micro"
  key_name = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id = aws_subnet.example.id
  associate_public_ip_address = true
  tags = {
    Name = var.project_name
  }
}

output "ip_address" {
  value = aws_instance.example.public_ip
}
