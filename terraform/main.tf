terraform {
  required_version = "~> 1.5.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.2"
    }
  }
  backend "s3" {
    bucket = "dj-library-terraform"
    key    = "terraform/state"
    region = "eu-west-2"
  }
}
#123
