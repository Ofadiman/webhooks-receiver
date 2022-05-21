resource "aws_key_pair" "webhooks_receiver_key_pair" {
  key_name   = "webhooks_receiver_key"
  public_key = file("./ssh-keys/webhooks_receiver_rsa.pub")
  tags       = {}
}
