resource "aws_kinesis_firehose_delivery_stream" "firehose_delivery_stream" {
  name        = "${var.prefix}-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.wsi_firehose_role.arn
    bucket_arn         = var.bucket_arn
    prefix             = "data/raw/%Y/%m/%d/%H"
    buffering_interval = 60
    buffering_size     = 5
  }

  kinesis_source_configuration {
    kinesis_stream_arn = var.kinesis_stream_arn
    role_arn           = aws_iam_role.wsi_firehose_role.arn
  }
}
