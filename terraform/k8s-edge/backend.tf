terraform {
  backend "kubernetes" {
    secret_suffix = "edge-state"
    config_path   = "../../.kubeconfigs/controller.yaml"
    namespace     = "kube-public"
  }
}