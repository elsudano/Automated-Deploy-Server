output my_vps_ip {
  value       = ovh_dedicated_server.myvps.ipv4_address
  description = "This is a IP of VPS instance"
}