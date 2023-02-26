# внешние ip адреса для node кластера Docker Swarm

output "external_ip_address_manager" {
  value = module.swarm_cluster[*].external_ip_address_manager
}

output "external_ip_address_worker" {
  value = module.swarm_cluster[*].external_ip_address_worker
}
