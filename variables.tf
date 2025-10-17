variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "cluster_name" {
  type    = string
  default = "chriswk.eu"   # used for hostnames; adjust to your domain or a placeholder
}

variable "datacenter_name" {
  type    = string
  default = "fsn1-dc14"   # pick your preferred DC
}

