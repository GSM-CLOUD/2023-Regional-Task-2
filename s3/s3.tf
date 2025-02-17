resource "aws_s3_bucket" "wsi-s3-bucket" {
  bucket = "${var.prefix}-99-ssss-etl"
  force_destroy = true
  tags = {
    "Name" = "${var.prefix}-99-ssss-etl"
  }
}

resource "aws_s3_object" "about-app" {
  bucket = aws_s3_bucket.wsi-s3-bucket.id
  key = "/data/raw/2022/01/01/samplelog.json"
  source = "${path.module}/file/samplelog.json"
  content_type = "application/json"
}

resource "aws_s3_object" "projects-app" {
  bucket = aws_s3_bucket.wsi-s3-bucket.id
  key = "/data/ref/titles.json"
  source = "${path.module}/file/titles.json"
  content_type = "application/json"
}