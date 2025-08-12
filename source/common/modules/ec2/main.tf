resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_groups
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = file(var.user_data_file)

  provisioner "file" {
    source      = "scripts/application.zip"
    destination = "/tmp/application.zip"
  }

  provisioner "file" {
    source      = "scripts/deployApp.sh"
    destination = "/tmp/deployApp.sh"
  }

  // User data script will be executed before these commands
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/deployApp.sh",
      "sudo /tmp/deployApp.sh"
  #    "sudo bash /app/neasaa/rajput/application/db-setup/init-db.sh",
  #    "sudo bash /app/neasaa/rajput/application/db-setup/setup-family-tree-database.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_key_file_path)
    host        = self.public_ip
  }

  tags = {
    Name = "terraform-web-instance"
  }
}