variable "hcloud_token" {}
variable "public_key" {}

terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.24.1"
    }
  }
}

provider "hcloud" {
    token = var.hcloud_token
}

resource "random_string" "name" {
    length = 6
    special = false
    upper = false
}

locals {
    name = "${terraform.workspace}-${random_string.name.result}"
}
