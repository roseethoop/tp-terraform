terraform {
  backend "s3" {
    bucket = "bucket-s3-share"
    key    = "dev/terrafrom.tfstate" # garde tel quel si déjà en prod
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

