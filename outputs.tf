output "talosconfig" {
  value     = module.talos.talosconfig
  sensitive = true
}

output "kubeconfig" {
  value     = module.talos.kubeconfig
  sensitive = true
}

output "control_plane_load_balancer_ipv4" {
  value = hcloud_load_balancer.control_plane.ipv4
}

output "control_plane_load_balancer_id" {
  value = hcloud_load_balancer.control_plane.id
}
