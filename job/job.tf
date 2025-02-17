resource "aws_glue_job" "glue_job" {
  name = "${var.prefix}-glue-job"
  role_arn = aws_iam_role.glue_job_role.arn

  command {
    script_location = "s3://${aws_s3_bucket.glue_job_script_bucket.bucket}/scripts/wsi-glue-job.py"
    python_version  = "3"
  }

  depends_on = [ aws_s3_object.glue_job_script ]
}