resource "aws_iam_role" "bastion_role" {
    name = "${var.prefix}-bastion-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF 
}

resource "aws_iam_policy_attachment" "bastion_role_policy" {
  name = "${var.prefix}-bastion-role-policy"
  roles = [aws_iam_role.bastion_role.name]
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_instance_profile" "bastion_profile" {
    name = "${var.prefix}-bastion-instance-profile"
    role = aws_iam_role.bastion_role.name
}

resource "aws_instance" "bastion" {
    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.prefix}-keypair"
    subnet_id = var.public_subnet_a_id
    iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
    vpc_security_group_ids = [aws_security_group.bastion_sg.id]

    tags = {
      Name = "${var.prefix}-bastion-ec2"
    }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  
  tags = {
    Name = "${var.prefix}-bastion-eip"
  }
}

