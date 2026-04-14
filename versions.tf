terraform {
  required_version = ">= 1.11.6"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.60.1"
    }

    imager = {
      source  = "hcloud-talos/imager"
      version = "~> 0.1"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.10.0"
    }

    onepassword = {
      source = "1password/onepassword"
      version = "~> 3.3.1"
    }
  }
}

provider "hcloud" {
  token = data.onepassword_item.hetzner_token.password
}

provider "imager" {
  token = data.onepassword_item.hetzner_token.password
}

provider "talos" {}

provider "onepassword" {
  service_account_token = var.op_service_account_token
}

locals {
  talos_version = "v1.12.3"
}

