resource "kubernetes_namespace" "monitoring_system" {
  metadata {
    name = "monitoring-system"
  }
}

resource "null_resource" "namespaces" {
  depends_on = [
    kubernetes_namespace.monitoring_system,
  ]
}
