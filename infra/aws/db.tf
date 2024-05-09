# db.tf | Database Configuration

# Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.app_name}-rds-subnet-group"
  description = "${var.app_name} RDS subnet group"
  subnet_ids  = aws_subnet.public.*.id
  tags = {
    Environment = var.app_environment
  }
}
# Security Group
resource "aws_security_group" "rds_sg" {
  name = "${var.app_name}-${var.app_env}-rds-sg"
  description = "${var.app_name} RDS Security Group"
  vpc_id = aws_vpc.mage_vpc.id

  tags = {
    Name = "${var.app_name}-${var.app_env}-rds-sg"
    Environment =  var.app_environment
  }

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 5432
  ingress {
      from_port = 5432
      to_port = 5432
      protocol  = "tcp"
      security_groups = ["${aws_security_group.service_security_group.id}"]
  }

  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# RDS Instance
resource "aws_db_instance" "rds" {
  identifier             = "${var.app_name}-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "14"
  instance_class         = "db.t3.micro"
  multi_az               = false
  db_name                = "mage"
  username               = "${var.database_user}"
  password               = "${var.database_password}"
  db_subnet_group_name   = "${aws_db_subnet_group.rds_subnet_group.id}"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot    = true
  publicly_accessible    = true

  tags = {
    Environment = var.app_environment
  }
}
