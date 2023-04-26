variable "token" {
    sensitive = true
}

variable "authorized_key" {
  sensitive = true
}

variable "root_user_pw" {
    sensitive = true
}

variable "region" {
    default = "eu-central"
}

variable "k8s_version" {
    default = "1.25"
}

variable  "label" {
    description = "Label for the cluster"
    default = "lm_cluster"
}

variable "tags" {
    default = ["k8s", "angular", "spring"]
    type = list(string)
}

variable "pools" {
    description = "Amount of nodes for cluster"
    type = list(object({
        type = string
        count = number
    }))
    default = [
        {
            type = "g6-standard-1"
            count = 6
        },
    ]
}

variable "email" {
    description = "Email for cert issuer"
    default = "jedo66@protonmail.com"
    type = string
}

variable "host" {
  description = "Host of LibriMem"
  default = "librimem.online"
  type = string

}

resource "random_string" "password" {
  length = 32
  special = true
  upper = true
  lower = true
}