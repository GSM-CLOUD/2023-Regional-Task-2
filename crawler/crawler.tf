resource "aws_glue_crawler" "crawler" {
  database_name = var.database_name
  name = "${var.prefix}-glue-crawler"
  role = aws_iam_role.crawler_role.arn

  s3_target {
    path = "s3://${var.bucket_name}/data/raw"
  }

  s3_target {
    path = "s3://${var.bucket_name}/data/ref"
  }
}