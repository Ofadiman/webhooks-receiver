resource "tls_private_key" "webhooks_receiver_private_key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "webhooks_receiver_private_key_local_file" {
  content         = tls_private_key.webhooks_receiver_private_key.private_key_pem
  file_permission = "0400"
  filename        = "webhooks_receiver_private_key.pem"
}

resource "aws_key_pair" "webhooks_receiver_key_pair" {
  key_name   = "webhooks_receiver_key"
  public_key = tls_private_key.webhooks_receiver_private_key.public_key_openssh
}
