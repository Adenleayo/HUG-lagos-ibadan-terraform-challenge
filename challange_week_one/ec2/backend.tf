
terraform {

  # adding backend as s3 for Remote state storage
  backend "s3" {
    bucket = "ade-terraform-bucket-state-2699"
    key    = "aws-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

 