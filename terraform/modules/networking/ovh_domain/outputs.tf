output subdomain {
  value       = join(".", [ovh_domain_zone_record.subdomain1.subdomain, ovh_domain_zone_record.subdomain1.zone])
  description = "The subdomain that's created"
}