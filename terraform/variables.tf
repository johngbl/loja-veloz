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

variable "do_token" {
  description = "DigitalOcean API token (set via environment or CI secret)"
  type        = string
  default     = ""
}

variable "region" {
  description = "DO region"
  type        = string
  default     = "nyc1"
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28.0-do.1"
}

variable "node_size" {
  description = "Droplet size for node pool"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "node_count" {
  description = "Default node count"
  type        = number
  default     = 2
}
