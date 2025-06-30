terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
  }
}

# The providers will automatically use the current context from your local kubeconfig
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# 1. Install ArgoCD
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "5.51.4"

  create_namespace = true
  skip_crds        = true

  values = [
    templatefile("${path.module}/argocd-values.yaml", {})
  ]
}

# 2. Install Prometheus
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = "monitoring"
  version    = "25.18.0"

  create_namespace = true

  values = [
    templatefile("${path.module}/../monitoring/prometheus-values.yaml", {})
  ]
}

# 3. Install Grafana
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"
  version    = "7.3.11"

  create_namespace = true

  values = [
    templatefile("${path.module}/../monitoring/grafana-values.yaml", {})
  ]
}

# 4. Create ArgoCD Application for the demo app
resource "kubernetes_manifest" "argocd_app" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "demo-app"
      "namespace" = "argocd"
    }
    "spec" = {
      "project" = "default"
      "source" = {
        "repoURL"        = "https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git" # <-- ⚠️ PLEASE REPLACE THIS
        "targetRevision" = "HEAD"
        "path"           = "manifests/app"
      }
      "destination" = {
        "server"    = "https://kubernetes.default.svc"
        "namespace" = "default"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"    = true
          "selfHeal" = true
        }
      }
    }
  }
}

# 5. Create Grafana Dashboards ConfigMap
resource "kubernetes_config_map" "grafana_dashboards" {
  metadata {
    name      = "grafana-dashboards"
    namespace = "monitoring"
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "k8s-cluster-overview.json" = file("${path.module}/../monitoring/grafana-dashboards/k8s-cluster-overview.json")
  }
}
