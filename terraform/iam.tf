provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "registration-lambda-role" {
  name               = "registration-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.registration-lambda-role-assume-role-policy.json
}

data "aws_iam_policy_document" "registration-lambda-role-assume-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "registration-lambda-role-policy" {
  role   = aws_iam_role.registration-lambda-role.id
  policy = data.aws_iam_policy_document.registration-lambda-role-policy.json
}



data "aws_iam_policy_document" "registration-lambda-role-policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["rekognition:*"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = ["logs:*"]
    resources = ["*"]
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.face-recognition-function-715.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.recognition-api-gateway.execution_arn}/*/*"
}