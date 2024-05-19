locals {
  HELM_ARGO_CD_VERSION        = "6.8.0"
  HELM_ARGO_EVENTS_VERSION    = "2.4.4"
  HELM_ARGO_WORKFLOWS_VERSION = "0.41.4"
  HELM_ARGO_ROLLOUTS_VERSION  = "2.35.2"
  cluster_sources             = { for filename in fileset("../../.kubeconfigs", "*.yaml") : filename => yamldecode(file("../../.kubeconfigs/${filename}")) }
  clusters = { for key, value in local.cluster_sources : value.clusters[0].name => {
    clusterName = value.clusters[0].name
    clusterType = value.clusters[0].name == "k3s-controller" ? "controller" : "edge"
    userName    = value.users[0].name
    user        = value.users[0].user
    cluster     = value.clusters[0].cluster
  } }
}