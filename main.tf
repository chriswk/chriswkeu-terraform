module "talos" {
  source             = "hcloud-talos/talos/hcloud"
  version            = "2.19.1"
  talos_version      = "v1.11.2"
  kubernetes_version = "1.34.1"
  cilium_version     = "1.18.2"
  hcloud_token       = var.hcloud_token

  cluster_name                        = var.cluster_name
  cluster_api_host                    = "kube.chriswk.eu"
  output_mode_config_cluster_endpoint = "cluster_endpoint"
  enable_floating_ip                  = true
  datacenter_name                     = var.datacenter_name

  firewall_use_current_ip = true

  control_plane_count       = 3
  control_plane_server_type = "cax11"

  worker_count       = 3
  worker_server_type = "cax21"
}

locals {
  load_balancer_location = split("-", var.datacenter_name)[0]
}

resource "hcloud_load_balancer" "control_plane" {
  name               = "${var.cluster_name}-control-plane"
  load_balancer_type = var.load_balancer_type
  location           = local.load_balancer_location

  labels = {
    cluster = var.cluster_name
    role    = "control-plane"
  }
}

resource "hcloud_load_balancer_service" "kube_api" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443

  health_check {
    protocol = "tcp"
    port     = 6443
    interval = 15
    retries  = 3
    timeout  = 5
  }
}

resource "hcloud_load_balancer_target" "control_plane" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  type             = "label_selector"
  use_private_ip   = true

  label_selector {
    selector = var.control_plane_label_selector
  }
}
