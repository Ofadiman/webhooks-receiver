resource "aws_security_group" "webhooks_receiver_security_group" {
  description = "Security Group used for EC2 hosting webhooks receiver server."
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "tcp"
    to_port     = 3000
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "tcp"
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_iam_instance_profile" "webhooks_receiver_instance_profile" {
  name = "WebhooksReceiverInstanceProfile"
  role = aws_iam_role.webhooks_receiver_role.name
}

resource "aws_eip" "webhooks_receiver_host_static_ip" {
  instance = aws_instance.webhooks_receiver_host.id
  tags     = {}
  vpc      = true
}

resource "aws_route53_record" "webhooks_receiver_host_dns_record" {
  name    = "webhooks-receiver.ofadiman.com"
  records = [aws_eip.webhooks_receiver_host_static_ip.public_ip]
  ttl     = "300"
  type    = "A"
  zone_id = data.aws_route53_zone.ofadiman_route53_hosted_zone.zone_id
}

resource "aws_instance" "webhooks_receiver_host" {
  ami                         = "ami-0c1bc246476a5572b"
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.webhooks_receiver_instance_profile.name
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.webhooks_receiver_key_pair.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  tags                        = {}
  vpc_security_group_ids      = [aws_security_group.webhooks_receiver_security_group.id]
  hibernation                 = true

  user_data = file("./scripts/bootstrap-ec2.sh")

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp2"
  }

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdf"
    encrypted             = true
    volume_size           = 8
    volume_type           = "gp2"
  }

  provisioner "file" {
    destination = "/home/ec2-user/${aws_key_pair.webhooks_receiver_key_pair.key_name}.pub"
    source      = "./ssh-keys/${aws_key_pair.webhooks_receiver_key_pair.key_name}.pub"

    connection {
      host        = self.public_ip
      private_key = file("./ssh-keys/${aws_key_pair.webhooks_receiver_key_pair.key_name}")
      type        = "ssh"
      user        = "ec2-user"
    }
  }

  provisioner "file" {
    destination = "/home/ec2-user/docker-compose.prod.yml"
    source      = "./../docker-compose.prod.yml"

    connection {
      host        = self.public_ip
      private_key = file("./ssh-keys/${aws_key_pair.webhooks_receiver_key_pair.key_name}")
      type        = "ssh"
      user        = "ec2-user"
    }
  }

  provisioner "remote-exec" {
    inline = ["chmod 400 ~/${aws_key_pair.webhooks_receiver_key_pair.key_name}.pub"]

    connection {
      host        = self.public_ip
      private_key = file("./ssh-keys/${aws_key_pair.webhooks_receiver_key_pair.key_name}")
      type        = "ssh"
      user        = "ec2-user"
    }
  }
}
