# rs.tf | Redshift Cluster

# Redshift Cluster
resource "aws_redshift_cluster" "dw" {
  cluster_identifier = "${var.project_name}-cluster"
  database_name      = "${var.rs_database_name}"
  master_username    = "${var.rs_master_username}"
  master_password    = "${var.rs_master_pass}"
  node_type          = "${var.rs_nodetype}"
  cluster_type       = "${var.rs_cluster_type}"

  cluster_subnet_group_name = aws_redshift_subnet_group.subnet_group.name
  skip_final_snapshot = true
  
  iam_roles = [ "${aws_iam_role.redshift_role.arn}" ]
  
  depends_on = [
    aws_vpc.redshift_vpc,
    aws_security_group.redshift_sg,
    aws_redshift_subnet_group.subnet_group,
    aws_iam_role.redshift_role
  ]
}

