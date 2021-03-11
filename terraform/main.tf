variable "hcloud_token" {}
variable "public_key" {}
variable "server_type" {}
variable "hetznerdns_token" {}
variable "dns_zone" {}
variable "dns_name" {}
variable "dns_fullname" {}

terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.24.1"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = "1.1.1"
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
