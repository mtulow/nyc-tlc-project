# =============== #
# AWS Credentials #
# =============== #

variable "AWS_ACCESS_KEY_ID" {
  type = string
  default = "AWS_ACCESS_KEY_ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  default = "AWS_SECRET_ACCESS_KEY"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-1"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
  default     = "709623555156"
}

variable "aws_profile" {
  type = string
  default = "terraform"
}

# ======= #
# Project #
# ======= #

variable "project_name" {
  type    = string
  default = "nyc-tlc"
}

# =========== #
# Application #
# =========== #

variable "app_count" {
  type = number
  default = 1
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "mage-server"
}

variable "app_env" {
  type        = string
  description = "Application Environment"
  default     = "dev"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
  default     = "development"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 30
}

# ============ #
# RDS Instance #
# ============ #

variable "DATABASE_CONNECTION_URL" {
  type    = string
  default = ""
}

variable "database_user" {
  type        = string
  description = "The username of the Postgres database."
  default     = "postgres"
}

variable "database_password" {
  type        = string
  description = "The password of the Postgres database."
  sensitive   = true
}

# ========== #
# ECR Values #
# ========== #

variable "docker_image" {
  description = "Docker image url used in ECS task."
  default     = "mageai/mageai:latest"
}

variable "ecr_repo_name" {
  type        = string
  description = "ECR repo name"
  default     = "mage-elt"
}

variable "ecr_image_tag" {
  type        = string
  description = "ECR docker image tag"
  default     = "latest"
}

# ========== #
# ECS Values #
# ========== #

variable "ecs_cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "ecs-cluster-name"
}

variable "ecs_service_name" {
  type        = string
  description = "ECS service name"
  default     = "ecs-service-name"
}

variable "ecs_container_name" {
  type        = string
  description = "ECS container name"
  default     = "ecs-container-name"
}

variable "ecs_task_role_name" {
  type        = string
  description = "ECS execution task role name"
  default     = "ecs-task-role-name"
}

variable "ecs_task_cpu" {
  description = "ECS task cpu"
  default     = 512
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  default     = 1024
}

# ============== #
# Network Values #
# ============== #

variable "mage_vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.32.0.0/16"
}

variable "mage_public_subnets" {
  description = "List of public subnets"
  default     = ["10.32.100.0/24", "10.32.101.0/24"]
}

variable "mage_private_subnets" {
  description = "List of private subnets"
  default     = ["10.32.0.0/24", "10.32.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["us-west-1a", "us-west-1c"]
}

# ================ #
# Redshift Cluster #
# ================ #

# Redshift VPC
variable "redshift_vpc_cidr" { }

# Subnets
variable "redshift_subnet_cidr_1" { }
variable "redshift_subnet_cidr_2" { }

# Redshift
variable "rs_cluster_identifier" { }
variable "rs_database_name" { }
variable "rs_master_username" { }
variable "rs_master_pass" { }
variable "rs_nodetype" { }
variable "rs_cluster_type" { }