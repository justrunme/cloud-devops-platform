# 1. Install Argo CD
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "10.10.2"

  create_namespace = true
  skip_crds        = false
  wait             = true
  timeout          = 600

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
  version    = "29.36.1"

  create_namespace = true
  wait             = true
  timeout          = 600

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
  version    = "10.5.15"

  create_namespace = true
  wait             = true
  timeout          = 600

  depends_on = [
    helm_release.prometheus
  ]

  values = [
    templatefile("${path.module}/../monitoring/grafana-values.yaml", {})
  ]
}

# 4. Create Grafana Dashboards ConfigMap
resource "kubernetes_config_map_v1" "grafana_dashboards" {
  depends_on = [
    helm_release.grafana
  ]
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

# 5. Create Argo CD Application for the demo app
resource "kubernetes_manifest" "argocd_app" {
  depends_on = [
    helm_release.argocd
  ]

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
        "repoURL"        = "https://github.com/justrunme/cloud-devops-platform.git"
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
