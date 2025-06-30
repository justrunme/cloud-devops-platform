terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.13"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "default" {
  name           = "cloud-devops-platform"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
      extra_port_mappings {
        container_port = 30000
        host_port      = 80
        protocol       = "TCP"
      }
      extra_port_mappings {
        container_port = 30001
        host_port      = 443
        protocol       = "TCP"
      }
    }
    node {
      role = "worker"
    }
  }
}

resource "local_file" "kubeconfig" {
  depends_on = [kind_cluster.default]
  content    = kind_cluster.default.kubeconfig
  filename   = "${path.module}/kubeconfig"
}
