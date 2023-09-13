resource "aws_key_pair" "mykey" {
  key_name   = "terra-key"
  public_key = file("/home/ubuntu/.ssh/terra-key.pub")
}

resource "aws_instance" "my-vpc-instance" {
  key_name        = aws_key_pair.mykey.key_name
  ami             = var.ec2-ubuntu-ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "Secured-instace"
  }
}

resource "aws_default_vpc" "default_vpc" {

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description = "TLS from VPC"
    protocol    = "TCP"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}

