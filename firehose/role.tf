resource "aws_iam_role" "wsi_firehose_role" {
  name               = "wsi-firehose-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "wsi_firehose_policy_attachment" {
  name       = "wsi-firehose-policy-attachment"
  roles      = [aws_iam_role.wsi_firehose_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
}

resource "aws_iam_policy_attachment" "wsi_s3_policy_attachment" {
  name       = "wsi-s3-policy-attachment"
  roles      = [aws_iam_role.wsi_firehose_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy" "wsi_firehose_custom_policy" {
  name        = "wsi-firehose-custom-policy"
  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "kinesis:DescribeStream"
        Resource = "arn:aws:kinesis:ap-northeast-2:323974325951:stream/wsi-data-stream"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "wsi_firehose_custom_policy_attachment" {
  name       = "wsi-firehose-custom-policy-attachment"
  roles      = [aws_iam_role.wsi_firehose_role.name]
  policy_arn = aws_iam_policy.wsi_firehose_custom_policy.arn
}
