
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
  public_key = var.ssh_public_key
}
