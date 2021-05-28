terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "template" {

}
