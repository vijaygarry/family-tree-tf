resource "aws_security_group" "https_sg" {
  name        = "https-sg-${var.vpc_id}"
  description = "Allow HTTPS inbound traffic only"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS inbound"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # port 8080 added for testing
  ingress {
    description = "Allow HTTPS inbound"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from allowed IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]
  }

  tags = { Name = "https-sg" }
}

resource "aws_network_acl" "https_nacl" {
  vpc_id = var.vpc_id

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = var.https_port
    to_port    = var.https_port
  }

  egress {
    rule_no    = 100
    protocol   = "-1"           # all protocols
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow SSH inbound from specific IP
  ingress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.allowed_ssh_ip
    from_port  = 22
    to_port    = 22
  }

  # Allow all incoming connection for yum install and postgres setup.
  # Once this setup is done, remove this config
  ingress {
   rule_no    = 105
   protocol   = "-1"
   action     = "allow"
   cidr_block = "0.0.0.0/0"
   from_port  = 0
   to_port    = 0
  }
  
  tags = { Name = "https-nacl" }
}


# Create a Network ACL association for each subnet
resource "aws_network_acl_association" "https_nacl_assoc" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  network_acl_id = aws_network_acl.https_nacl.id
}
