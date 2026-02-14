// Terraform skeleton to provision a managed Kubernetes cluster (DOKS example)
// Chosen provider: DigitalOcean (DOKS) for MVP because it's simple to provision,
// has a straightforward Terraform provider, and is cost-effective for small clusters.
// Replace with GKE/AKS/EKS blocks if you prefer your cloud provider.

terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

// Create a Kubernetes cluster (DigitalOcean DOKS)
resource "digitalocean_kubernetes_cluster" "loja_veloz_cluster" {
  name    = "loja-veloz-cluster"
  region  = var.region
  version = var.k8s_version

  node_pool {
    name       = "default-pool"
    size       = var.node_size
    node_count = var.node_count
  }
}

// Configure kubernetes provider using the cluster's kubeconfig
provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.loja_veloz_cluster.kube_configs[0].host
  token                  = digitalocean_kubernetes_cluster.loja_veloz_cluster.kube_configs[0].token
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.loja_veloz_cluster.kube_configs[0].cluster_ca_certificate)
}

resource "kubernetes_namespace" "loja_veloz" {
  metadata {
    name = "loja-veloz"
    labels = {
      name = "loja-veloz"
    }
  }
}

output "kube_cluster_name" {
  value = digitalocean_kubernetes_cluster.loja_veloz_cluster.name
}

