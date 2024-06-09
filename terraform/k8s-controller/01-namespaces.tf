resource "kubernetes_namespace" "argo_system" {
  metadata {
    name = "argo-system"
  }
}

resource "kubernetes_namespace" "monitoring_system" {
  metadata {
    name = "monitoring-system"
  }
}

resource "kubernetes_namespace" "kuma_system" {
  metadata {
    name = "kuma-system"
  }
}

resource "null_resource" "namespaces" {
  depends_on = [
    kubernetes_namespace.argo_system,
    kubernetes_namespace.monitoring_system,
    kubernetes_namespace.kuma_system,
  ]
}
