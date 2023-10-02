output "cognito_userpool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "cognito_identitypool_id" {
  value = aws_cognito_identity_pool.id.id
}

output "frontend_bucket" {
  value = aws_s3_bucket.frontend.id
}

output "storage_bucket" {
  value = aws_s3_bucket.storage.id
}

output "api_gw" {
  value = aws_apigatewayv2_stage.apigw.invoke_url
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.web.website_endpoint
}