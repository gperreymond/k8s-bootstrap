resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = local.HELM_ARGO_CD_VERSION

  namespace = kubernetes_namespace.argo_system.id
  values = [
    "${file("values/argo-cd.yaml")}"
  ]

  depends_on = [
    null_resource.namespaces
  ]
}

resource "null_resource" "argo" {
  depends_on = [
    helm_release.argo_cd
  ]
}