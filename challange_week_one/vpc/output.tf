output "vpc_id" {
  description = "The id of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The id of the public subnet"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "The id of the private subnet"
  value       = aws_subnet.private.*.id
}

output "vpc_cidr_block" {
  description = "ouput for the cidr block"
  value       = aws_vpc.main.cidr_block
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

output "azs" {
  value = data.aws_availability_zones.available.names
}
#
output "internet_gateway_vpc_id" {
  description = "The id of the internet gateway"
  value       = aws_internet_gateway.adenle-Igw.vpc_id
  sensitive   = true
}

output "internet_gateway_name" {
  description = "The name of the internet gateway"
  value       = aws_internet_gateway.adenle-Igw.tags["Name"]
}

output "internet_gateway_id" {
  description = "The id of the internet gateway"
  value       = aws_internet_gateway.adenle-Igw.id
  sensitive   = true
}

output "nat_gateway_id" {
  description = "The id of the NAT gateway"
  value       = aws_nat_gateway.ade-nat-gateway.association_id
  #sensitive   = true
}

output "nat_gateway_public_ip" {
  description = "The public IP of the NAT gateway"
  value       = aws_nat_gateway.ade-nat-gateway.public_ip
  #sensitive   = true
}

output "elastic_ip_id" {
  description = "The id of the Elastic IP"
  value       = aws_eip.ade-eip.public_dns
  # sensitive   = true
}
output "route_table" {
  description = "The id of the route table"
  value       = aws_route_table.ade-priv-RT.id

}