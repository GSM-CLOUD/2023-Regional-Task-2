output "bucket_arn" {
    value = aws_s3_bucket.wsi-s3-bucket.arn
}

output "bucket_name" {
    value = aws_s3_bucket.wsi-s3-bucket.bucket
}