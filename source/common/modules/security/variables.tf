variable "vpc_id" {
  description = "VPC ID to create security group in"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate the NACL with"
  type        = list(string)
}

variable "https_port" {
  description = "Port number for HTTPS"
  type        = number
}

# Variable for allowed SSH IP
variable "allowed_ssh_ip" {
  description = "The public IP address allowed to connect via SSH (CIDR format)"
  type        = string
}