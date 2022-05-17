
# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "4.14.0"
#     }
#   }
# }

provider "aws" {
  region = "ap-southeast-3"
  shared_credentials_files = [ "aws_credentials" ]
}
