resource "hetznerdns_zone" "zone" {
  name = var.dns_zone
  ttl  = 60
}

resource "hetznerdns_record" "jellyfin_A" {
  zone_id = hetznerdns_zone.zone.id
  name    = var.dns_name
  value   = hcloud_server.server.ipv4_address
  type    = "A"
  ttl     = 60
}

#resource "hetznerdns_record" "jellyfin_AAAA" {
#    zone_id = hetznerdns_zone.zone.id
#    name = var.dns_name
#    value = hcloud_server.server.ipv6_address
#    type = "AAAA"
#    ttl = 60
#}

# CAA records
## Don't allow issuing wildcard certs
resource "hetznerdns_record" "zone_CAA_nowildcards" {
  zone_id = hetznerdns_zone.zone.id
  name    = "@"
  value   = "0 issuewild \";\""
  type    = "CAA"
  ttl     = 3600
}

## Only allow letsencrypt to issue certs for this zone
resource "hetznerdns_record" "zone_CAA" {
  zone_id = hetznerdns_zone.zone.id
  name    = "@"
  value   = "0 issue \"letsencrypt.org\""
  type    = "CAA"
  ttl     = 3600
}
