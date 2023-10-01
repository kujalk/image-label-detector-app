resource "aws_dynamodb_table" "dbtable" {
  name           = "${var.project}_detectlabels"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "cognitoid"
  range_key      = "imagename"

  attribute {
    name = "cognitoid"
    type = "S"
  }

  attribute {
    name = "imagename"
    type = "S"
  }

  tags = {
    Project = "${var.project}"
  }
}