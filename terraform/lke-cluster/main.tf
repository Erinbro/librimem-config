terraform {
  required_providers {
    linode = {
        source = "linode/linode"
        version = "1.27.1"
    }
  }

}

provider "linode" {
    token = var.token
}




resource "linode_lke_cluster" "lm_cluster" {
  k8s_version = var.k8s_version
  label = var.label
  region = var.region
  tags = var.tags

  dynamic "pool" {
    for_each = var.pools
    content {
      type = pool.value["type"]
      count = pool.value["count"]
    }
  }
  
}



# data "linode_object_storage_cluster" "primary" {
#   id = var.region
# }

# resource "linode_object_storage_bucket" "tf_state" {
#   cluster = data.linode_object_storage_cluster.primary
#   label = "lm-tf-state"
# }

resource "linode_nodebalancer" "lm-nb" {
  label = "lm-nb"
  region = var.region
}

resource "linode_nodebalancer_config" "lm-nb-config" {
  nodebalancer_id = linode_nodebalancer.lm-nb.id
  port = 80
  protocol = "http"
  check = "http_body"
  check_path = "/healthcheck/"
  check_body = "healthcheck"
  check_attempts = 30
  check_timeout = 25
  check_interval = 30
  stickiness = "http_cookie"
  algorithm = "roundrobin"
}

resource "linode_nodebalancer_node" "lm-nb-node" {
  count = 1
  nodebalancer_id = linode_nodebalancer.lm-nb.id
  config_id = linode_nodebalancer_config.lm-nb-config.nodebalancer_id
  label = "lm-nb-node"
  address = "${element(linode_instance.lm-instance.*.private_ip_address, count.index)}"
  mode = "accept"
}

resource "linode_instance" "lm-instance" {
  count = 1
  label = "lm-instance"
  group = "lm-nb"
  tags = ["lm-nb"]
  region = var.region
  type = "g6-nanode-1"
  image = "linode/ubuntu20.04"
  authorized_keys = [ chomp(var.authorized_key) ]
  root_pass = random_string.password.result
  private_ip = false

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt-get -q update",
      "mkdir -p /var/www/html",
      "mkdir -p /var/www/html/healthcheck",
      "echo healthcheck > /var/www/html/healthcheck/index.html",
      "echo node ${count.index + 1} > /var/www/html/index.html",
      "apt-get -q -y install nginx"
    ]

    connection {
      type = "ssh"
      user = "root"
      password = random_string.password.result
      host = self.ip_address

    }
    
  }
  
}



output "kubeconfig" {
  value = linode_lke_cluster.lm_cluster.kubeconfig
  sensitive = true
}

output "status" {
  value = linode_lke_cluster.lm_cluster.status
}

output "id" {
  value = linode_lke_cluster.lm_cluster.id
}

output "pool" {
  value = linode_lke_cluster.lm_cluster.pool
}

output "lm-nb-ip-address" {
  value = linode_nodebalancer.lm-nb.ipv4
  
}