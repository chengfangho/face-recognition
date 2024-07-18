resource "aws_dynamodb_table" "faces-715" {
  name           = "faces-715"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key = "rekognition_id"
  attribute {
    name = "rekognition_id"
    type = "S"
  }
}