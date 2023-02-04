# AWS EC2 instance 

# adding security group to ec2
resource "aws_security_group" "web-sg" {
  name = "stanley-dev-sg"
  ingress {
    from_port   = 22 
    to_port     = 22
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

# create a key-pair
resource "aws_key_pair" "stanley-dev-key-pair" {
  key_name   = "stanley-dev-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2Pc3gUTw5nLp2lp+iIz+SzLl9OXXu3Fpm2Nt/5Z5wfv4g3IHoJDQC9FHeSGLtI5AvKBX8A6kwknTHq86vrrx6cscB+w4HOvSen4HojrLePzf+6XLp69TI3qebnT1dHPFkiqcHcrUTE7Ar2bE+5DXN1FR8jR/vanaEv7BJx0uR8bf9H8IZbvxmA0uQxEJp8FrqJA4GwkcH8hu8SfiCUdeu59tNjQlCGOWamygkLtr1bbyi4mDG+s/gn2Ss8RQsCo2KWLDRrePTrrSyQjwZ9cx3KZmNjdceQwBd/ksIr3QfWdKmiRq7g8lzUH0feVWbiwtk+ng0hO8pUCRCvc3WILr28lf1p2VOX8efLS6EBzwyCCNmiE3kW1PVEIFcHNF0G9xdUglzKKVxBN6JZJB2LHL8T21N62q3P4VlnCTggZGcxY1R9DJx5ClbWxk9tGxUiC5V/3m8LzVyHxvT5dB/qLVuIJGPPNVFvCsmpnhya4zgYNSr6Dh6oRF55q2HOGwQv/6BQwh3ROi/aEnM3D5a/SYdNQn9JcFX1xmd1KDs+4ymJ6DclJVUFGQv6Ptr1Ttp6mJNX1f5YZUt7PZ4zkw5gAvDzKDX4fBqSg1kuvF0D21MOfOY4ps0cwNreSBbRtOd4T5wnspKwa10tjXQbEud9/wD43RLt3C/j5tnSLdAimQZGw== stanleyyv@gmail.com"
}

# instance is in region us-west-1
resource "aws_instance" "webservers" {
  ami                    = "ami-0f5e8a042c8bfcd5e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "stanley-dev-key-pair"

  tags = {
    Name = "stanley-dev-us-west-2"
    terraform = "True"
  }
}

# Autoscaling group
resource "aws_launch_template" "webservers" {
  name_prefix = "webservers"
  image_id = "ami-0f5e8a042c8bfcd5e"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "webservers" {
  availability_zone = ["us-west-2a"]
  desired_capcity = 1
  max_size = 5
  min_size = 1
  launch_template {
    id = aws_launch_template.webservers.id
    version = "$Latest"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.webservers.id
  vpc = true
}

/*
CLI:
teraform init
teraform apply
yes
--> EC2 instance will be seen
*/

