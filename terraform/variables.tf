variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "vpc_name" {
  description = "Define name for vpc"
  type        = string
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Valid values are default and dedicated."
  type        = string
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Valid values are true and false."
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Valid values are true and false."
  type        = bool
}

variable "azs" {
  description = "AZ for vpc"
  type        = list(string)
}

variable "vpc_priv_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "priv_name" {
  description = "Name for private subnets"
  type        = string
}

variable "vpc_pub_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "pub_name" {
  description = "Name for public subnets"
  type        = string
}

variable "rtb_cidr" {
  description = "CIDR block for route table"
  type        = string
}

variable "rtb_name" {
  description = "Name for route table"
  type        = string
}

variable "instance_type" {
  description = "Instance Type for EC2"
  type        = string
}

variable "ami" {
  description = "AMI for EC2"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "key_pair_name" {
  description = "Name of the key pair to use for EC2 instances"
  type        = string
}

variable "allow_ssh" {
  description = "List of CIDR blocks allowed to SSH into the bastion host"
  type        = list(string)
}

variable "key_name" {
  description = "key name for bastion host"
  type        = string
}

variable "public_key_path" {
  description = "Path to the public key file for the bastion host"
  type        = string
}

variable "rds_priv" {
  type        = string
  description = "Private subnet for RDS"
}

variable "rds_name" {
  type        = string
  description = "RDS Name"
}

variable "db_name" {
  type        = string
  description = "DB Name"
}

variable "engine" {
  type        = string
  description = "RDS Engine"
}

variable "engine_version" {
  type        = string
  description = "RDS Engine Version"
}

variable "db_class" {
  type        = string
  description = "RDS Class"
}

variable "user" {
  type        = string
  description = "RDS User Name"
}

variable "encrypt" {
  type        = bool
  description = "Storage Encrypt for RDS"
}

variable "storage_type" {
  type        = string
  description = "Storage Type for RDS"
}

variable "storage" {
  type        = string
  description = "Total Storage size for RDS"
}

variable "multi" {
  type        = string
  description = "Multi AZs for RDS"
}

variable "skip" {
  type        = string
  description = "Skip Snapshot for RDS"
}

variable "final" {
  type        = string
  description = "Final Snapshot for RDS"
}

variable "apply" {
  type        = string
  description = "Apply immediately for RDS"
}

variable "max" {
  type        = string
  description = "Max Storage for RDS"
}

variable "db_password" {
  type        = string
  description = "Password for RDS database"
  sensitive   = true
}

variable "rds_sg" {
  type        = string
  description = "Security Group for RDS"
}