// Define input variables for the root module

variable "environment" {
  description = "Deployment environment (e.g., uat, prod)"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "https_port" {
  description = "Port number to allow HTTPS traffic"
  type        = number
  default     = 443
}

# Variable for allowed SSH IP
variable "allowed_ssh_ip" {
  description = "The public IP address allowed to connect via SSH (CIDR format)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "AWS availability zone for subnet"
  type        = string
  default     = "us-east-1a"
}

variable "user_data_file" {
  description = "Path to shell script file to run on EC2 instance startup"
  type        = string
}

variable "ssh_key_file_path" {
  description = "Path to ssh key file"
  type        = string
}