variable "op_password_uuid_hetzner_token" {
  type      = string
  sensitive = true
}

variable "op_service_account_token" {
  type      = string
  sensitive = true
}

variable "op_vault_id_terraform" {
  type      = string
  sensitive = true
}

variable "cluster_name" {
  type    = string
}

variable "datacenter_name" {
  type    = string
}