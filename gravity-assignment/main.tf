
#Required provider for terraform 
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
  }
}
# cloud provide details
provider "google" {
  project     = "blissful-racer-425921-i5"
  region      = "us-central1"
  credentials = file("../credentials/blissful-racer-425921-i5-d8d851e2617e.json")
}


# variable for subnets 
variable "subnets" {
  description = "Map of subnet"
  type = map(object({
    name         = string
    ip_cidr_range = string
  }))
  default = {
    public  = {
      name          = "public-subnet"
      ip_cidr_range  = "10.0.0.0/24"
    }
    private = {
      name          = "private-subnet"
      ip_cidr_range  = "10.0.1.0/24"
    }
  }
}


#------------------------------------- 
# Create the VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# Create subnets using the object type variable
resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets

  name          = each.value.name
  ip_cidr_range  = each.value.ip_cidr_range
  network        = google_compute_network.vpc_network.id
  region         = "us-central1"
}

# Create a Compute Engine instance in the public subnet
resource "google_compute_instance" "web_instance" {
  name         = "web-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  tags         = ["http-server", "https-server"]

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet["public"].id
    access_config {
    }
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11-bullseye-v20210817"
    }
  }
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOT
}

# Create a firewall rule to allow HTTP and HTTPS traffic
resource "google_compute_firewall" "new_firewall" {
  name    = "allow-http-https"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  
  target_tags = ["http-server", "https-server"]
}
