resource "kind_cluster" "default" {
  name           = "cloud-devops-platform"
  wait_for_ready = true
  # tehcyx/kind ~> 0.11 embeds kind v0.31.0; pin a digest from that release.
  # Prefer v1.34.x over v1.35+ for broader cgroup compatibility on CI runners.
  node_image = "kindest/node:v1.34.3@sha256:08497ee19eace7b4b5348db5c6a1591d7752b164530a36f855cb0f2bdcbadd48"

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
  }
}

resource "local_file" "kubeconfig" {
  depends_on = [kind_cluster.default]
  content    = kind_cluster.default.kubeconfig
  filename   = "${path.module}/kubeconfig"
}
