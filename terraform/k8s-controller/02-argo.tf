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

resource "kubernetes_secret" "argo_cd_clusters" {
  for_each = { for cluster in local.clusters : cluster.clusterName => cluster }
  metadata {
    name      = each.value.clusterName
    namespace = kubernetes_namespace.argo_system.id
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }
  type = "Opaque"

  data = yamldecode(<<YAML
name: "${each.value.clusterName}"
server: "${each.value.cluster.server}"
config: |
  {
    "tlsClientConfig": {
      "insecure": false,
      "caData": "${each.value.cluster["certificate-authority-data"]}",
      "certData": "${each.value.user["client-certificate-data"]}",
      "keyData": "${each.value.user["client-key-data"]}"
    }
  }
YAML
  )

  depends_on = [
    helm_release.argo_cd
  ]
}

resource "kubernetes_manifest" "argocd_projects" {
  for_each = { for filepath in fileset("./argo-cd/projects", "*.yaml") : filepath => filepath }

  manifest = yamldecode(templatefile("./argo-cd/projects/${each.key}", {
    argo_cd_namespace = kubernetes_namespace.argo_system.id
  }))

  depends_on = [
    helm_release.argo_cd
  ]
}

resource "null_resource" "argo" {
  depends_on = [
    helm_release.argo_cd,
    kubernetes_secret.argo_cd_clusters,
    kubernetes_manifest.argocd_projects
  ]
}
