resource "aws_instance" "demo" {

  ami = lookup(var.AMI, var.REGION)
  instance_type = var.INSTANCE_TYPE
  key_name = var.KEY_NAME
  
  tags = {
	  Name = var.TAGS
  }

  security_groups = [aws_security_group.allow_access.name]
}

resource "aws_eip" "myeip" {
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.demo.id
  allocation_id = aws_eip.myeip.id
}

resource "aws_security_group" "allow_access" {
  name        = "ssh_http"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
