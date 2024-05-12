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

resource "kubernetes_manifest" "argo_cd_project_edge" {
  manifest = yamldecode(<<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: edge
  namespace: ${kubernetes_namespace.argo_system.id}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: All applications to deploy in each "edge" clusters
  sourceRepos:
    - '*'
  namespaceResourceWhitelist:
    - group: '*'
      kind: '*'
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
  destinations:
    - namespace: argo-system
      server: https://kubernetes.default.svc
      name: in-cluster
    - namespace: kube-system
      server: https://kubernetes.default.svc
      name: in-cluster
YAML
  )

  depends_on = [
    helm_release.argo_cd
  ]
}

resource "null_resource" "argo" {
  depends_on = [
    helm_release.argo_cd,
    kubernetes_manifest.argo_cd_project_edge
  ]
}