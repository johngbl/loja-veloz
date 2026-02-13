variable "kubeconfig_path" {
  description = "Path to kubeconfig for the Kubernetes provider"
  type        = string
  default     = "~/.kube/config"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "loja-veloz-cluster"
}
