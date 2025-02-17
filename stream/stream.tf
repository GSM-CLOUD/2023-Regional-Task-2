resource "aws_kinesis_stream" "kinesis_stream" {
  name = "${var.prefix}-data-stream"
  shard_count = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Name = "${var.prefix}-data-stream"
  }
}