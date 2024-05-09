# iam.tf | IAM Role Policies

# ============ #
# ECS Task IAM #
# ============ #

# Role
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.app_environment
  }
}
# Policy Document
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
# Policy Attachment
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# =================== #
# Lambda Function IAM #
# =================== #

# Role
resource "aws_iam_role" "lambda_role" {
  name   = "${var.app_name}-lambda-role"
  assume_role_policy = file("../policies/assume_lambda_role.json")
}
# Policy Document
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name         = "${var.app_name}_policy_for_lambda_role"
  path         = "/"
  description  = "IAM Policy for managing ${var.app_name} lambda role"
  policy = file("../policies/lambda_policy.json")
}
# Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_lambda_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# ==================== #
# Redshift Cluster IAM #
# ==================== #

# Policy
resource "aws_iam_role_policy" "s3_full_access_policy" {
  name = "redshift_s3_policy"
  role = "${aws_iam_role.redshift_role.id}"
  policy = file("../policies/s3_full_access.json")
}
# IAM Role
resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"
  assume_role_policy = file("../policies/assume_redshift_role.json")
  tags = {
    tag-key = "redshift-role"
  }
}
