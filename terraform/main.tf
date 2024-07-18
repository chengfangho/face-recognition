# face-registration-function-715 invoke when image is uploaded to face-registration-bucket-715 for registration
resource "aws_lambda_function" "face-registration-function-715" {
  function_name                  = "face-registration-function-715"
  role                           = aws_iam_role.registration-lambda-role.arn
  handler                        = "registration.main.lambda_handler"
  runtime                        = "python3.10"
  timeout                        = 10
  memory_size                    = 500                                                    
  s3_bucket                      = aws_s3_bucket.rekognition-deployment-package-bucket-715.bucket 
  s3_key                         = aws_s3_object.rekognition-lambda_zip.key   
  s3_object_version              = aws_s3_object.rekognition-lambda_zip.version_id                
}

resource "aws_lambda_function" "face-recognition-function-715" {
  function_name                  = "face-recognition-function-715"
  role                           = aws_iam_role.registration-lambda-role.arn
  handler                        = "recognition.main.lambda_handler"
  runtime                        = "python3.10"
  timeout                        = 10
  memory_size                    = 500                                                    
  s3_bucket                      = aws_s3_bucket.rekognition-deployment-package-bucket-715.bucket 
  s3_key                         = aws_s3_object.rekognition-lambda_zip.key   
  s3_object_version              = aws_s3_object.rekognition-lambda_zip.version_id                
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.face-registration-function-715.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.face-registration-bucket-715.arn
}

resource "aws_s3_bucket_notification" "rekognition-lambda-trigger" {
    bucket = aws_s3_bucket.face-registration-bucket-715.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.face-registration-function-715.arn
        events              = ["s3:ObjectCreated:*"]
    }
    depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_cloudwatch_log_group" "registration-function-log-group" {
  name              = "/aws/lambda/face-registration-function-715"
  retention_in_days = 30
}