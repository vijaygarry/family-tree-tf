variable "subnet_id" {
  description = "Subnet ID for EC2 instance"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs to assign to EC2 instance"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
}

variable "user_data_file" {
  description = "Path to shell script file for EC2 user data"
  type        = string
}

variable "ssh_key_file_path" {
  description = "Path to ssh key file"
  type        = string
}