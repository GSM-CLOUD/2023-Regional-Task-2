resource "aws_s3_bucket" "glue_job_script_bucket" {
    bucket = "${var.prefix}-glue-job-script-99-ssss"
    force_destroy = true

    tags = {
      Name = "${var.prefix}-glue-job-script-99-ssss"
    }
}

resource "aws_s3_object" "glue_job_script" {
    bucket = aws_s3_bucket.glue_job_script_bucket.id
    key = "scripts/wsi-glue-job.py"
    source = "${path.module}/file/wsi-glue-job.py"
    content_type = "text/x-python"
}
