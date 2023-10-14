data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_instance_profile" "ec2_ecr_connection" {
  name = "ec2_ecr_connection"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "allow_ec2_access_ecr"
  path = "/"

  assume_role_policy = <<EOF
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

resource "aws_iam_role_policy" "access_ecr_policy" {
  name = "allow_ec2_access_ecr"
  role = aws_iam_role.role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_launch_template" "presentation_tier" {
  name = "presentation_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ecr_connection.name
  }

  instance_type = "t2.nano"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.presentation_tier.id]
  }

  user_data = base64encode(templatefile("./../user-data/user-data-presentation-tier.sh", {
    application_load_balancer = aws_lb.application_tier.dns_name,
    ecr_url                   = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    ecr_repo_name             = var.ecr_presentation_tier,
    region                    = var.region
  }))

  depends_on = [
    aws_lb.application_tier
  ]
}

resource "aws_launch_template" "application_tier" {
  name = "application_tier"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ecr_connection.name
  }

  instance_type = "t2.nano"
  image_id      = data.aws_ami.amazon_linux_2.id

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.application_tier.id]
  }

  user_data = base64encode(templatefile("./../user-data/user-data-application-tier.sh", {
    rds_hostname  = module.rds.rds_address,
    rds_username  = var.rds_db_admin,
    rds_password  = var.rds_db_password,
    rds_port      = 3306,
    rds_db_name   = var.db_name
    ecr_url       = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    ecr_repo_name = var.ecr_application_tier,
    region        = var.region
  }))

  depends_on = [
    aws_nat_gateway.gw
  ]
}