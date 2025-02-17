resource "aws_iam_role" "wsi_api_role" {
  name               = "wsi-api-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "wsi_api_role_policy_attachment" {
  name       = "wsi-api-role-policy-attachment"
  roles      = [aws_iam_role.wsi_api_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}
