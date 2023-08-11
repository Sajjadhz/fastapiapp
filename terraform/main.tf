terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
    }
  }
}
provider "lxd" {
  generate_client_certificates = true
  accept_remote_certificate    = true
}

resource "lxd_storage_pool" "pool1" {
  name = "local"
  driver = "dir"
  config = {}
}

resource "lxd_volume" "volume1" {
  name = "myvolume"
  pool = "${lxd_storage_pool.pool1.name}"
}

resource "lxd_network" "new_default" {
  name = "lxdfan0"

  config = {
    "ipv4.address" = "240.235.0.1/24"
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:474b:622d:259d::1/64"
    "ipv6.nat"     = "true"
  }
}
resource "lxd_profile" "profile1" {
  name = "k8s"

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = "${lxd_network.new_default.name}"
    }
  }
 device {
    type = "disk"
    name = "root"

    properties = {
      pool = "local"
      path = "/"
    }
  }
}
# Create LXC Container
resource "lxd_container" "nodes" {
  for_each = toset( ["kmaster", "kworker1", "kworker2"] )    
  name      = each.key
  image     = "ubuntu:22.04"
  ephemeral = false
  profiles  = ["k8s"]
  device {
    name = "volume1"
    type = "disk"
    properties = {
      path = "/opt/"
      source = "${lxd_volume.volume1.name}"
      pool = "${lxd_storage_pool.pool1.name}"
    }
   } 
}
