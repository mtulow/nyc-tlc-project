# Resources:
# - Mage Server
# - Storage
# - Executers
# AWS_REGION: ...
# CONTAINER_NAME: ...
# ECR_REPOSITORY: ...
# ECS_CLUSTER: ...
# ECS_SERVICE: ...
# ECS_TASK_DEFINITION: ...

# 

# - Elastic Container Service (ECS):
#   - ...


# - Application Load Balancer (ALB):
#   - ...

# - Elastic File System (EFS):
#   - ...


# - Relational Database Service (RDS):
#   - ...
output "postgres_database" {
  value = aws_db_instance.rds.address
}


# ECS Task Role ARN
output "task_role_arn" {
  description = "ARN for ECS task execution role"
  value = aws_iam_role.ecsTaskExecutionRole.arn
}

# =========== #
# Mage Server #
# =========== #

# Mage Web Servers
output "mage_server_dns" {
  description = "The web address for the Mage Web Server."
  value = aws_alb.application_load_balancer.dns_name
}

# ========= #
# IAM Roles #
# ========= #
output "s3_iam_role" {
  description = "IAM Role for S3 bucket."
  value = aws_iam_role.redshift_role.name
}
output "lambda_iam_role" {
  description = "The IAM Role for the lambda function."
  value = aws_iam_role.lambda_role.name
}
output "redshift_iam_role" {
  description = "IAM Role for Redshift Cluster database."
  value = aws_iam_role.redshift_role.arn
}

# ========= #
# Data Lake #
# ========= #

# Data Lake: S3 Bucket
output "s3_bucket" {
  description = "The URI of the S3 Bucket."
  value = aws_s3_bucket.dl.bucket
}

# ============== #
# Data Warehouse #
# ============== #

# Data Warehouse: Redshift Cluster
output "redshift_cluster_dns" {
  description = "Redshift cluster DNS"
  value = aws_redshift_cluster.dw.dns_name
}
# Data Warehouse: Admin username
output "redshift_cluster_admin_username" {
  description = "Redshift Cluster Admin username."
  value = aws_redshift_cluster.dw.master_username
}
# Data Warehouse: Admin username
output "redshift_cluster_admin_password" {
  description = "Redshift Cluster admin password."
  value = aws_redshift_cluster.dw.master_password
  sensitive = true
}