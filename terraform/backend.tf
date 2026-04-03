terraform {
  backend "s3" {
    region  = "ap-southeast-1"
    bucket  = "demo-todo-app-terraform"
    key     = "uat-demo/terraform.tfstate"
    encrypt = true
  }
}