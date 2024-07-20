# Create EC2 instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                service httpd start
                chkconfig httpd on
              EOF

  tags = {
    Name = "web_instance"
  }
}
