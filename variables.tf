variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "cluster_name" {
  type    = string
  default = "chriswk.eu" # used for hostnames; adjust to your domain or a placeholder
}

variable "datacenter_name" {
  type    = string
  default = "fsn1-dc14" # pick your preferred DC
}

variable "load_balancer_type" {
  type        = string
  default     = "lb11"
  description = "Hetzner load balancer type for the control plane ingress."
}

variable "control_plane_label_selector" {
  type        = string
  default     = "controlplane=true"
  description = "Label selector used to discover control plane servers for the load balancer."
}
