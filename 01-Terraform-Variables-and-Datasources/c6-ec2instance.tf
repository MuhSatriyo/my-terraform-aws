# EC2 Instance
resource "aws_instance" "myec2vm" {
  ami                    = data.aws_ami.ubuntu2204.id
  instance_type          = var.instance_type
  user_data              = file("${path.module}/app1-install.sh")
  key_name               = var.instance_keypair
  subnet_id              = aws_subnet.default_subnet.id
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id ]
  tags = {
    "Name" = "EC2 Demo 2"
  }
}
