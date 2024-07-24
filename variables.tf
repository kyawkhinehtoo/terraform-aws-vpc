variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of the Public Subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the Private Subnet"
  type        = string
}

variable "internet_gateway_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "public_route_table_name" {
  description = "Name of the Public Route Table"
  type        = string
}

variable "private_route_table_name" {
  description = "Name of the Private Route Table"
  type        = string
}

variable "natgateway_name" {
  description = "Name of the Nat Gatway"
  type        = string
}

variable "eip_id" {
  description = "Elastic IP Id"
  type        = string
}

variable "public_internet_destination_cidr" {
  description = "Destination CIDR for the Public Internet Route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "security_group_name" {
  type        = string
  description = "Name of AWS Security Group"
}
variable "security_group_description" {
  type        = string
  description = "Description of AWS Security Group"
}


variable "ami_id" {
  type        = string
  description = "AMI ID"
}
variable "instance_type" {
  type        = string
  description = "Instance Type"
}
variable "instance_name" {
  type        = string
  description = "Instance Name"
}
variable "private_key_algorithm" {
  type        = string
  description = "Algorithm for Private Key"
}
variable "private_key_ras_bit" {
  type        = string
  description = "RSA Bit for Private Key"
}
variable "aws_key_pair_key_name" {
  type        = string
  description = "Key Pair Name for Aws"
}
