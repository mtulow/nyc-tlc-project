# Resources:
# - Mage Server
# - Storage
# - Executers


# 

# - Elastic Container Service (ECS):
#   - ...


# - Application Load Balancer (ALB):
#   - ...
output "alb_dns" {
  description = "The DNS of the mage server."
  value =  aws_alb.application_load_balancer.dns_name
}

# - Elastic File System (EFS):
#   - ...


# - Relational Database Service (RDS):
#   - ...
output "postgres_database" {
  value = aws_db_instance.rds.address
}