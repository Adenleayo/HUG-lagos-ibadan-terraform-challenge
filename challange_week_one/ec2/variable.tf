variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "hug-web-server"
}

variable "ec2_ami" {
  description = "list of all ec2 ami"
  type        = string
  default     = "ami-0b6d9d3d33ba97d99"

}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "ade-terraform-bucket-state-2699"
}

variable "bucket_folder" {
  description = "Name of bucket folder"
  type        = string
  default     = "Hug_ec2_public_keys"
}

variable "ec2_port_number" {
  description = "value of ec2 port number"
  type        = list(number)
  default     = [22, 80]
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t3.micro"
}