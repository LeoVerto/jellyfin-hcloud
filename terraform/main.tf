terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.35.0"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "2.1.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

resource "random_string" "name" {
  length  = 6
  special = false
  upper   = false
}

locals {
  name = "${terraform.workspace}-${random_string.name.result}"
}
