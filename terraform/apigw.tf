resource "aws_api_gateway_rest_api" "recognition-api-gateway" {
  name = "recognition-api-gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "recognition-api-gateway-resource-bucket" {
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  parent_id   = aws_api_gateway_rest_api.recognition-api-gateway.root_resource_id
  path_part   = "{bucket}"
}

resource "aws_api_gateway_resource" "recognition-api-gateway-resource-filename" {
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  parent_id   = aws_api_gateway_resource.recognition-api-gateway-resource-bucket.id
  path_part   = "{filename}"
}


resource "aws_api_gateway_method" "recognition-api-method"{
    authorization = "NONE"
    http_method = "PUT"
    resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
    rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
}

resource "aws_api_gateway_resource" "recognition-api-gateway-resource-person" {
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  parent_id   = aws_api_gateway_rest_api.recognition-api-gateway.root_resource_id
  path_part   = "person"
}

resource "aws_api_gateway_method" "recognition-api-method-person"{
    authorization = "NONE"
    http_method = "GET"
    resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
    rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
}
