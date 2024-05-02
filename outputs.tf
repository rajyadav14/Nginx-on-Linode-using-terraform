output "web_servers_ips" {
  value = linode_instance.webserver1.*.private_ip_address
}

output "node_balancer_ip_hostname" {
  value = linode_nodebalancer.mynodebalancer.hostname
}

output "node_balancer_ip" {
  value = linode_nodebalancer.mynodebalancer.ipv4
}
