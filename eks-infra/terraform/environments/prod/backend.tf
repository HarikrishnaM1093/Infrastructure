terraform {
  backend "s3" {
    bucket         = "YOUR_TF_STATE_BUCKET"
    key            = "eks/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
