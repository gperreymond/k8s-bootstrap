resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "oci://ghcr.io/argoproj/argo-helm"
  chart      = "argo-cd"
  version    = local.HELM_ARGO_CD_VERSION

  namespace = kubernetes_namespace.argo_system.id
  values = [
    "${file("values/argo-cd.yaml")}", <<YAML
clusterCredentials: []
YAML
  ]

  depends_on = [
    null_resource.namespaces,
  ]
}

resource "kubernetes_secret" "argo_cd_clusters" {
  for_each = { for cluster in local.clusters : cluster.clusterName => cluster }
  metadata {
    name      = each.value.clusterName
    namespace = kubernetes_namespace.argo_system.id
    labels = {
      "argocd.argoproj.io/secret-type"   = "cluster"
      "gperreymond/argocd-deployer-all"  = "true"
      "gperreymond/argocd-deployer-name" = each.value.clusterName
      "gperreymond/argocd-deployer-type" = each.value.clusterType
      "gperreymond/loadBalancer-ip"      = each.value.loadBalancerIP
    }
  }
  type = "Opaque"

  data = yamldecode(<<YAML
name: "${each.value.clusterName}"
server: "${each.value.cluster.server}"
config: |
  {
    "username": "${each.value.userName}",
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
    helm_release.argo_cd,
  ]
}

resource "kubernetes_manifest" "argocd_projects" {
  for_each = { for filepath in fileset("./argo-cd/projects", "*.yaml") : filepath => filepath }

  manifest = yamldecode(templatefile("./argo-cd/projects/${each.key}", {
    argo_cd_namespace = kubernetes_namespace.argo_system.id
  }))

  depends_on = [
    helm_release.argo_cd,
  ]
}

resource "kubernetes_manifest" "argocd_applications" {
  for_each = { for filepath in fileset("./argo-cd/applications", "*.yaml") : filepath => filepath }

  manifest = yamldecode(templatefile("./argo-cd/applications/${each.key}", {
    argo_cd_namespace           = kubernetes_namespace.argo_system.id
    prometheus_namespace        = kubernetes_namespace.monitoring_system.id
    stakater_reloader_namespace = "kube-public"
    traefik_namespace           = kubernetes_namespace.traefik_system.id
    metallb_namespace           = "kube-system"
    clusters                    = local.clusters
    prometheus = {
      targetRevision = "25.30.1"
    }
    stakaterReloader = {
      targetRevision = "1.1.0"
    }
    traefik = {
      targetRevision = "33.0.0"
    }
    metallb = {
      targetRevision = "0.14.8"
    }
  }))

  depends_on = [
    helm_release.argo_cd,
    kubernetes_secret.argo_cd_clusters,
    kubernetes_manifest.argocd_projects,
  ]
}

resource "null_resource" "argo" {
  depends_on = [
    helm_release.argo_cd,
    kubernetes_secret.argo_cd_clusters,
    kubernetes_manifest.argocd_projects,
    kubernetes_manifest.argocd_applications,
  ]
}
