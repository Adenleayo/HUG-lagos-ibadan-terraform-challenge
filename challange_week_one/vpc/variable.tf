variable "s3_object_name" {
  description = "Name of the S3 object"
  type        = string
  default     = "HUG-dev"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "ade-terraform-bucket-state-26"
}

variable "aws_vpc" {
  description = "vpc name"
  type        = string
  default     = "hug-vpc"
}
variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}