resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "${var.prefix}-api"
  tags = {
    Name = "${var.prefix}-api"
  }
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_method" "post_api" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.post_api.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:${var.region}:kinesis:action/PutRecord"
  credentials             = aws_iam_role.wsi_api_role.arn

  request_templates = {
    "application/json" = <<EOF
{
    "StreamName": "wsi-data-stream",
    "Data": "$util.base64Encode($input.json('$'))",
    "PartitionKey": "$context.requestId"
}
EOF
  }

}
