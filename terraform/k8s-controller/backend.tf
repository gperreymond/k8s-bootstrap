terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "../../.kubeconfigs/controller/kubeconfig.yaml"
    namespace     = "kube-public"
  }
}