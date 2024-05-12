terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "../../.kubeconfigs/controller.yaml"
    namespace     = "kube-public"
  }
}