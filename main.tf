resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  count                       = length(var.ec2_name)
  subnet_id                   = data.aws_subnet.selected.id
  key_name                    = var.ec2_key
  security_groups             = [aws_security_group.new_sg.id]
  associate_public_ip_address = true



  tags = {
    Name = var.ec2_name[count.index]
    # Name = var.ec2_name
  }
}

resource "aws_security_group" "new_sg" {
  description = "internet access for public subnet"
  name        = "new_sg"
  tags = {
    name = "new_sg"
  }
  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

