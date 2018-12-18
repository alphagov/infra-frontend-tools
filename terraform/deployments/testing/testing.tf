data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_iam_role" "testing" {
  name = "testing-ec2"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "testing_ssm" {
  role       = "${aws_iam_role.testing.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "testing" {
  name = "${aws_iam_role.testing.name}"
  role = "${aws_iam_role.testing.name}"
}

resource "aws_security_group" "testing" {
  name = "testing"
  description = "testing"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "testing" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.small"

  iam_instance_profile = "${aws_iam_instance_profile.testing.name}"

  security_groups = [
    "${aws_security_group.testing.name}"
  ]

  root_block_device {
    volume_size = 100
  }

  tags {
    Name = "testing"
  }
}

resource "aws_eip" "testing" {}

resource "aws_eip_association" "testing" {
  instance_id   = "${aws_instance.testing.id}"
  allocation_id = "${aws_eip.testing.id}"
}

output "testing_ip" {
  value = "${aws_eip.testing.public_ip}"
}
