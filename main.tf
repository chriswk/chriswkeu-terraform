module "talos" {
  source = "hcloud-talos/talos/hcloud"
  version = "2.19.1"
  talos_version = "v1.11.2"
  kubernetes_version = "1.34.1"
  cilium_version = "1.18.2"
  hcloud_token = var.hcloud_token

  cluster_name = var.cluster_name
  cluster_api_host = "kube.chriswk.eu"
  output_mode_config_cluster_endpoint = "cluster_endpoint"
  enable_floating_ip = true
  datacenter_name = var.datacenter_name

  firewall_use_current_ip = true

  control_plane_count = 3
  control_plane_server_type = "cax11"

  worker_count = 3
  worker_server_type = "cax21"
}
