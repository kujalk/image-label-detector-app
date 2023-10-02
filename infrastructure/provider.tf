provider "aws" {
  region  = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "gitactiontf"
    key    = "labelappstate"
    region = "ap-southeast-1"
  }
}