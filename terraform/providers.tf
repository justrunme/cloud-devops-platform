terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "kind" {}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig"
  }
}
