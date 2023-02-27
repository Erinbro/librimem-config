resource "local_file" "kubeconfig" {
    filename = "kube-config"
    content = base64decode(linode_lke_cluster.lm_cluster.kubeconfig)
}

resource "local_file" "api_endpoints" {
    filename = "api_endpoints"
    content = join(", ", linode_lke_cluster.lm_cluster.api_endpoints)
}

output "api_endpoints" {
  depends_on = [
    linode_lke_cluster.lm_cluster
  ]
  value = linode_lke_cluster.lm_cluster.api_endpoints
}
