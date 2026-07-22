# HUG Lagos/Ibadan Terraform Challenge - Week One

## Project Overview

This project was completed as part of the HUG Lagos/Ibadan Terraform Challenge Week One.

The objective of this project was to provision a basic web server on AWS using Terraform and Infrastructure as Code (IaC).

The infrastructure provisions a custom VPC, public subnet, Internet Gateway, route table, security group, and EC2 instance.

The EC2 instance is configured using a `user_data` boot script to automatically install Nginx and serve a simple HTML webpage.

The webpage displays:

- My Full Name: Adenle Ayomide
- HUG Lagos/Ibadan Terraform Challenge

---

## Architecture

The infrastructure follows this architecture:

Internet
   |
   v
Internet Gateway
   |
   v
Route Table
   |
   v
Public Subnet
   |
   v
EC2 Instance
   |
   v
Nginx Web Server
   |
   v
HTML Webpage

---

## Infrastructure Components

The following AWS resources were provisioned using Terraform:

- Custom VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance

The Security Group allows:

- SSH traffic on port 22
- HTTP traffic on port 80

The EC2 instance is deployed in the public subnet and configured to run Nginx.

---

## Project Structure

```text
challenge_week_one/
│
├── vpc/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ...
│
├── ec2/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── userdata.sh
│   └── ...
│
└── README.md

## Prerequisites

- AWS Account
- Terraform
- AWS CLI
- Configured AWS Credentials

---

## Deployment

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply -auto-approve

---

## Destroy

terraform destroy -auto-approve

---

## Output

After deployment:

terraform output


