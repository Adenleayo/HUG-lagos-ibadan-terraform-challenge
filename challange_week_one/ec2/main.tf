data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ade-terraform-bucket-state-2699"
    key    = "HUG_ec2/terraform.tfstate"
    region = "us-east-1"
  }
}
resource "tls_private_key" "rsa-keys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance-key" {
  key_name   = "${var.instance_name}-public-key"
  public_key = tls_private_key.rsa-keys.public_key_openssh
}


resource "local_file" "rsa_private" {
  filename        = "${path.module}/public-key.pem"
  content         = tls_private_key.rsa-keys.private_key_pem
  file_permission = "600"
}

# resource "terraform_data" "aws_key_pair" {
#   depends_on = [local_file.rsa_private]

#   provisioner "local-exec" {
#     command = "chmod 600 ${local_file.rsa_private}"
#   }
# }
# data "aws_subnet" "public_subnet" {
#   filter {
#     name   = "tag:Name"
#     values = ["my-public-subnet"]
#   }
# }

#aws security group for ec2 instance
resource "aws_security_group" "web_sg" {
  name        = "${var.instance_name}-web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.ec2_port_number
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  #outbound port number
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create ec2 instance
resource "aws_instance" "web" {
  ami                         = var.ec2_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.instance-key.key_name
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  associate_public_ip_address = true
  user_data                   = file("userdata.sh")
  ##file("${path.module}/userdata.sh")

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_s3_object" "private_key_s3" {
  bucket = var.bucket_name
  key    = "${var.bucket_folder}/private-key.pem"
  #source = local_file.rsa_private.filename
  content = tls_private_key.rsa-keys.private_key_pem
  acl     = "private"
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [local_file.rsa_private,
    aws_key_pair.instance-key
  ]


}
locals {
  private-key = "${path.module}/public-key.pem"
}

# resource "terraform_data" "get_private_key" {
#   provisioner "local_exec" {

#   }

# }