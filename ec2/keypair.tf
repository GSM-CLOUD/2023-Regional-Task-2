resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.prefix}-keypair"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "private_key_pair" {
  filename        = "./${var.prefix}-keypair.pem"
  content         = tls_private_key.private_key.private_key_pem
  file_permission = "0600"
}
