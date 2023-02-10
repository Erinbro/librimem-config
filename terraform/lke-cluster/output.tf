resource "local_file" "kubeconfig" {
    depends_on = [
linode_lke_cluster.lm_cluster
    ]
    filename = "kube-config"
    content = base64decode(linode_lke_cluster.lm_cluster.kubeconfig)
}

# resource "local_file" "api_endpoints" {
#     depends_on = [
#       linode_lke_cluster.lm_cluster
#     ]
#     filename = "api_endpoints"
#     content = linode_lke_cluster.lm_cluster.api_endpoints
# }

output "api_endpoints" {
  depends_on = [
    linode_lke_cluster.lm_cluster
  ]
  value = linode_lke_cluster.lm_cluster.api_endpoints
}

resource "local_file" "lm-nb-address" {
    depends_on = [
      linode_nodebalancer.lm-nb
    ]
    filename = "lm-nb-ip"
    content =  linode_nodebalancer.lm-nb.ipv4
  
}