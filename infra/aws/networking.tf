# networking.tf | Network Configuration

# ======= #
# Mage AI #
# ======= #

# Internal Gateway (for VPC)
resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.mage_vpc.id
  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.app_environment
  }

}
# Subnet: private
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.mage_vpc.id
  count             = length(var.mage_private_subnets)
  cidr_block        = element(var.mage_private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}
# Subnet: public
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.mage_vpc.id
  cidr_block              = element(var.mage_public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.mage_public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mage_vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-public"
    Environment = var.app_environment
  }
}
# Public Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
}
# Route Table Association
resource "aws_route_table_association" "public" {
  count          = length(var.mage_public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# ================ #
# Redshift Cluster #
# ================ #

# Internet Gateway (for VPC)
resource "aws_internet_gateway" "redshift_vpc_gw" {
  vpc_id = aws_vpc.redshift_vpc.id
  depends_on = [ aws_vpc.redshift_vpc ]
}
# Default Security Group for VPC
resource "aws_security_group" "redshift_sg" {
  vpc_id = aws_vpc.redshift_vpc.id

  # ingress = {
  #   from_port   = "5439"
  #   to_port     = "5439"
  #   protocol    = "tcp"
  #   cidr_blocks = [ "0.0.0.0/0" ]
  # }

  tags = {
    Name        = "${var.project_name}-sg"
    Environment = var.app_environment
  }

  depends_on = [ aws_vpc.redshift_vpc ]
}
# Subnets: redshift_subnet_1
resource "aws_subnet" "redshift_subnet_1" {
  vpc_id                  = aws_vpc.redshift_vpc.id
  cidr_block              = var.redshift_subnet_cidr_1
  availability_zone       = element(var.availability_zones, 0)
  map_public_ip_on_launch = true

  tags = {
    Name        = "redshift_subnet_1"
    Environment = var.app_environment
  }

  depends_on = [ aws_vpc.redshift_vpc ]
}
# Subnets: redshift_subnet_2
resource "aws_subnet" "redshift_subnet_2" {
  vpc_id                  = aws_vpc.redshift_vpc.id
  cidr_block              = var.redshift_subnet_cidr_2
  availability_zone       = element(var.availability_zones, 1)
  map_public_ip_on_launch = true

  tags = {
    Name        = "redshift_subnet_2"
    Environment = var.app_environment
  }

  depends_on = [ aws_vpc.redshift_vpc ]
}
# Redshift Subnet Group
resource "aws_redshift_subnet_group" "subnet_group" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = [ "${aws_subnet.redshift_subnet_1.id}", "${aws_subnet.redshift_subnet_2.id}" ]
  
  tags = {
    Environment = var.app_environment
    Name        = "${var.project_name}-subnet-group"
  }
}
