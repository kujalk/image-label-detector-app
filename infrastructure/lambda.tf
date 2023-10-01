//lambda to retrieve image from s3 and send to dynamodb
resource "aws_lambda_function" "s3_lambda" {
  filename         = var.s3_lambda_zip
  function_name    = "${var.project}-s3-lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "detectlabels.lambda_handler"
  publish          = true
  source_code_hash = filebase64sha256(var.s3_lambda_zip)
  runtime          = "python3.9"
  timeout          = 900

  environment {
    variables = {
      DynamoDB_Table = aws_dynamodb_table.dbtable.name
    }
  }

}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.storage.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.storage.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

//lambda to integrate with api-gw
resource "aws_lambda_function" "apigw_lambda" {
  filename         = var.apigw_lambda_zip
  function_name    = "${var.project}-apigw-lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "apigw.lambda_handler"
  publish          = true
  source_code_hash = filebase64sha256(var.apigw_lambda_zip)
  runtime          = "python3.9"
  timeout          = 900

  environment {
    variables = {
      DynamoDB_Table  = aws_dynamodb_table.dbtable.name
      IdentityPool_ID = aws_cognito_identity_pool.id.id
    }
  }

}

resource "aws_lambda_permission" "allow_apigw" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apigw_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apigw.execution_arn}/*/*/api/v1/identify"
}