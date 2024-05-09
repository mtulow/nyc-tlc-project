# vpc.tf | VPC Configuration

# ======= #
# Mage AI #
# ======= #

resource "aws_vpc" "mage_vpc" {
  cidr_block           = var.mage_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.app_name}-vpc"
    Environment = var.app_environment
  }
}

# ================ #
# Redshift Cluster #
# ================ #

resource "aws_vpc" "redshift_vpc" {
  cidr_block       = "${var.redshift_vpc_cidr}"
  instance_tenancy = "default"
  tags = {
    Name = "${var.project_name}-vpc"
  }
}
