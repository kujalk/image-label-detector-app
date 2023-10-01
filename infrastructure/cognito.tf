resource "aws_cognito_user_pool" "user_pool" {
  name                     = "${var.project}-userpool"
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.project}_client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_identity_pool" "id" {
  identity_pool_name               = "${var.project}-idpool"
  allow_unauthenticated_identities = false
  allow_classic_flow               = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.client.id
    provider_name           = aws_cognito_user_pool.user_pool.endpoint
    server_side_token_check = false
  }


}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.id.id
  roles = {
    "authenticated" = aws_iam_role.cognito.arn
  }
}