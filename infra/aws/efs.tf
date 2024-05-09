# efs.tf | Elastic File System Configuration

# File System
resource "aws_efs_file_system" "file_system" {
  encrypted         = true
  performance_mode  = "generalPurpose"
  throughput_mode   = "elastic"

  tags = {
    Name        = "${var.app_name}-efs"
    Environment = var.app_environment
  }
}
# Mount Target
resource "aws_efs_mount_target" "mount_target" {
  count = length(aws_subnet.public)
  file_system_id = aws_efs_file_system.file_system.id
  subnet_id      = aws_subnet.public[count.index].id
  security_groups = [ aws_security_group.mount_target_security_group.id ]
}
# Security Group
resource "aws_security_group" "mount_target_security_group" {
  vpc_id = aws_vpc.mage_vpc.id

  ingress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.service_security_group.id]
  }

  tags = {
    Name        = "${var.app_name}-efs-sg"
    Environment = var.app_environment
  }
}
