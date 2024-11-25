locals {
  HELM_ARGO_CD_VERSION        = "7.7.3"
  HELM_ARGO_EVENTS_VERSION    = "2.4.8"
  HELM_ARGO_WORKFLOWS_VERSION = "0.42.7"
  cluster_sources             = { for filename in fileset("../../.kubeconfigs", "*.yaml") : filename => yamldecode(file("../../.kubeconfigs/${filename}")) }
  clusters = { for key, value in local.cluster_sources : value.clusters[0].name => {
    clusterName    = value.clusters[0].name
    clusterType    = value.clusters[0].name == "k3s-controller" ? "controller" : "edge"
    loadBalancerIP = value.clusters[0].name == "k3s-controller" ? "172.29.2.100" : "172.29.2.200"
    userName       = value.users[0].name
    user           = value.users[0].user
    cluster        = value.clusters[0].cluster
  } }
}