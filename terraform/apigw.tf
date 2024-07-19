resource "aws_api_gateway_rest_api" "recognition-api-gateway" {
  name = "recognition-api-gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  binary_media_types = ["image/png", "image/jpg", "image/jpeg"]
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

#
resource "aws_api_gateway_method" "recognition-api-method-filename-put"{
    authorization = "NONE"
    http_method = "PUT"
    resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
    rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
    request_parameters = {
        "method.request.path.bucket"   = true
        "method.request.path.filename" = true
    }
}

resource "aws_api_gateway_method_response" "recognition-api-method-response-filename-put" {
  http_method = "PUT"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "false"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_method" "recognition-api-method-filename-option"{
    authorization = "NONE"
    http_method = "OPTIONS"
    resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
    rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
}

resource "aws_api_gateway_method_response" "recognition-api-method-response-filename-option" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "false"
    "method.response.header.Access-Control-Allow-Methods" = "false"
    "method.response.header.Access-Control-Allow-Origin"  = "false"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration" "recognition-api-integration-filename-option" {
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  resource_id          = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
  rest_api_id          = aws_api_gateway_rest_api.recognition-api-gateway.id
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_method" "recognition-api-method-bucket-option"{
    authorization = "NONE"
    http_method = "OPTIONS"
    resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-bucket.id
    rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
}

resource "aws_api_gateway_method_response" "recognition-api-method-response-bucket-option" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-bucket.id
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "false"
    "method.response.header.Access-Control-Allow-Methods" = "false"
    "method.response.header.Access-Control-Allow-Origin"  = "false"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration" "recognition-api-integration-bucket-option" {
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  resource_id          = aws_api_gateway_resource.recognition-api-gateway-resource-bucket.id
  rest_api_id          = aws_api_gateway_rest_api.recognition-api-gateway.id
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration" "recognition-api-integration-filename-put" {
  connection_type         = "INTERNET"
  credentials             = aws_iam_role.api_gateway_role.arn
  http_method             = "PUT"
  integration_http_method = "PUT"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters = {
    "integration.request.path.bucket"   = "method.request.path.bucket"
    "integration.request.path.filename" = "method.request.path.filename"
  }
  resource_id          = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
  rest_api_id          = aws_api_gateway_rest_api.recognition-api-gateway.id
  timeout_milliseconds = "29000"
  type                 = "AWS"
  uri                  = "arn:aws:apigateway:us-west-2:s3:path/{bucket}/{filename}"
}

resource "aws_api_gateway_integration_response" "recognition-api-integration-response-filename-option" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "recognition-api-integration-response-bucket-option" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-bucket.id
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "recognition-api-integration-response-filename-put" {
  http_method = "PUT"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-filename.id
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}



resource "aws_api_gateway_resource" "recognition-api-gateway-resource-person" {
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  parent_id   = aws_api_gateway_rest_api.recognition-api-gateway.root_resource_id
  path_part   = "person"
}

resource "aws_api_gateway_method" "recognition-api-method-person-get"{
    authorization = "NONE"
    http_method = "GET"
    resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
    rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
}

resource "aws_api_gateway_method" "recognition-api-method-person-option"{
    authorization = "NONE"
    http_method = "OPTIONS"
    resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
    rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
}

resource "aws_api_gateway_method_response" "recognition-api-method-response-person-get" {
  http_method = "GET"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "false"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_method_response" "recognition-api-method-response-person-option" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "false"
    "method.response.header.Access-Control-Allow-Methods" = "false"
    "method.response.header.Access-Control-Allow-Origin"  = "false"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration" "recognition-api-integration-person-get" {
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = aws_api_gateway_method.recognition-api-method-person-get.http_method
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
  rest_api_id             = aws_api_gateway_rest_api.recognition-api-gateway.id
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.face-recognition-function-715.invoke_arn
}

resource "aws_api_gateway_integration" "recognition-api-integration-person-option" {
  connection_type      = "INTERNET"
  http_method          = "OPTIONS"
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
  resource_id             = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
  rest_api_id             = aws_api_gateway_rest_api.recognition-api-gateway.id
  timeout_milliseconds = "29000"
  type                 = "MOCK"
}

resource "aws_api_gateway_integration_response" "recognition-api-integration-response-person-get" {
  http_method = "GET"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "recognition-api-integration-response-person-option" {
  http_method = "OPTIONS"
  resource_id = aws_api_gateway_resource.recognition-api-gateway-resource-person.id
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
  status_code = "200"
}

resource "aws_api_gateway_deployment" "recognition_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.recognition-api-gateway.id
}

resource "aws_api_gateway_stage" "recognition-api-dev" {
  deployment_id         = aws_api_gateway_deployment.recognition_api_deployment.id
  rest_api_id           = aws_api_gateway_rest_api.recognition-api-gateway.id
  stage_name            = "dev"
}

output "api_gateway_invoke_url" {
  value = aws_api_gateway_deployment.recognition_api_deployment.invoke_url
}