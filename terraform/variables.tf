# Hetzner cloud token for the project you want to create the server in.
variable "hcloud_token" {}
# Hetzner DNS API token.
variable "hetznerdns_token" {}
# Public ssh key to add to the server.
variable "public_key" {}

# DNS zone name to use, e.g. "example.com".
variable "dns_zone" {}
# Subdomain name to use, e.g. "jellyfin". Set to "@" to use the zone domain.
variable "dns_name" {}
# Full domain name, e.g. "jellyfin.example.com"
variable "dns_fullname" {}

# Server type to use for the instance. Defaults to smalles possible.
variable "server_type" {
  default = "cx11"
}
# Which location to use for the instance. Defaults to Nuremberg.
variable "location" {
  default = "nbg1"
}
