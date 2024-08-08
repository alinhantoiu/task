provider "aws" {
  version = "~> 5.0"
  region  = "us-east-1"
}

provider "helm" {
  kubernetes {
    config_path = "./k3s.yaml"
  }
}