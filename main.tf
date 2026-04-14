terraform {
  backend "s3" {
    bucket = "chriswkeutfstate"
    endpoints = {
      s3 = "https://hel1.your-objectstorage.com"
    }
    key                         = "chriswkeu.tfstate"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
    skip_s3_checksum            = true
  }
}

resource "talos_image_factory_schematic" "x86" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = []
      }
    }
  })
}

resource "talos_image_factory_schematic" "arm64" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = []
      }
    }
  })
}

data "talos_image_factory_urls" "hcloud_amd64" {
  talos_version = "v1.12.3"
  schematic_id  = talos_image_factory_schematic.x86.id
  platform      = "hcloud"
  architecture  = "amd64"
}

data "talos_image_factory_urls" "hcloud_arm64" {
  talos_version = "v1.12.3"
  schematic_id = talos_image_factory_schematic.arm64.id
  platform = "hcloud"
  architecture = "arm64"
}

resource "imager_image" "talos_x86" {
  image_url    = data.talos_image_factory_urls.hcloud_amd64.urls.disk_image
  architecture = "x86"
  description  = "Talos Linux v1.12.3 x86 chriswkeu"

  labels = {
    version = "v1.12.3"
    architecture = "x86"
  }
}

resource "imager_image" "talos_arm64" {
  image_url = data.talos_image_factory_urls.hcloud_arm64.urls.disk_image
  architecture = "arm64"
  description = "Talos Linux v1.12.3 arm64 chriswkeu"

  labels = {
    version = "v1.12.3"
    architecture = "arm64"
  }
}

module "talos" {
  source             = "hcloud-talos/talos/hcloud"
  version            = "3.2.3"
  talos_version      = "v1.12.3"
  talos_image_id_x86 = imager_image.talos_x86.id
  kubernetes_version = "1.35.3"
  disable_arm        = true
  hcloud_token       = var.hcloud_token

  enable_floating_ip      = true
  firewall_use_current_ip = true
  cluster_name            = "chriswkeu"
  location_name           = "hel1"
  cilium_values           = [templatefile("${path.module}/ciliumvalues/values.yaml", {})]
  control_plane_nodes = [
    { id = 1, type = "cx23" },
    { id = 2, type = "cx23" },
    { id = 3, type = "cx23" },
  ]

  worker_nodes = [
    { id = 1, type = "cx33" },
    { id = 2, type = "cx23" },
  ]

  kube_api_extra_args = {
    enable-aggregator-routing = true
  }

  sysctls_extra_args = {
    # Fix for https://github.com/cloudflare/cloudflared/issues/1176
    "net.core.rmem_default" = "26214400"
    "net.core.wmem_default" = "26214400"
    "net.core.rmem_max"     = "26214400"
    "net.core.wmem_max"     = "26214400"
  }

  kernel_modules_to_load = [
    { name = "binfmt_misc" } # Required for QEMU in gha-runner-system runners
  ]

  # Cilium bootstrap values - GitOps manages post-bootstrap (ArgoCD in my case)
  deploy_cilium  = true # set to false after first deployment and let GitOps handle upgrades
  cilium_version = "1.19.2"
  # cilium_values  = [templatefile("../path/to/your/git-ops/cilium/values.yaml", {})]

  deploy_prometheus_operator_crds  = true # set to false after first deployment and let GitOps handle upgrades
  prometheus_operator_crds_version = "26.0.0"

  deploy_hcloud_ccm = true # set to false after first deployment and let GitOps handle upgrades

  disable_talos_coredns = false # set to true after first deployment and let GitOps handle upgrades
  network_ipv4_cidr = "10.0.0.0/16"
  node_ipv4_cidr = "10.0.1.0/24"
  pod_ipv4_cidr = "10.0.16.0/20"
  service_ipv4_cidr = "10.0.8.0/21"


}
