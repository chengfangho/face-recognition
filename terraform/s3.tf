# rekognition-deployment-package-bucket-715 for lambda deployment
resource "aws_s3_bucket" "rekognition-deployment-package-bucket-715" {
  bucket = "rekognition-deployment-package-bucket-715"
}

resource "aws_s3_object" "rekognition-lambda_zip" {
  bucket = aws_s3_bucket.rekognition-deployment-package-bucket-715.bucket
  key    = "lambda.zip"
}

resource "aws_s3_bucket_versioning" "rrekognition-deployment-package-bucket-715-versioning" {
  bucket = aws_s3_bucket.rekognition-deployment-package-bucket-715.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# face-registration-bucket-715 for registration
resource "aws_s3_bucket" "face-registration-bucket-715" {
  bucket = "face-registration-bucket-715"
}

resource "aws_s3_bucket_versioning" "face-registration-bucket-715-versioning" {
  bucket = aws_s3_bucket.face-registration-bucket-715.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# face-recognition-bucket-715 for recognition
resource "aws_s3_bucket" "face-recognition-bucket-715" {
  bucket = "face-recognition-bucket-715"
}

resource "aws_s3_bucket_versioning" "face-recognition-bucket-715-versioning" {
  bucket = aws_s3_bucket.face-recognition-bucket-715.bucket
  versioning_configuration {
    status = "Enabled"
  }
}