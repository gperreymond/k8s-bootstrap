resource "kubernetes_namespace" "argo_system" {
  metadata {
    name = "argo-system"
  }
}

resource "null_resource" "namespaces" {
  depends_on = [
    kubernetes_namespace.argo_system
  ]
}
