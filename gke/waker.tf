terraform {
  backend "gcs" {
    bucket  = "YOUR_BUCKET"
    path    = "waker/terraform.tfstate"
    project = "YOUR_PROJECT"
  }
}

provider "google" {
  project = "YOUR_PROJECT"
  region  = "asia-northeast"
}

variable "master_username" {
  type = "string"
}
variable "master_password" {
  type = "string"
}
resource "google_container_cluster" "primary" {
  name               = "waker"
  zone               = "asia-northeast1-a"
  initial_node_count = 1

#   additional_zones = [
#     "asia-northeast1-b",
#     "asia-northeast1-c",
#   ]

  master_auth {
    username = "${var.master_username}"
    password = "${var.master_password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    disk_size_gb = 10
    machine_type = "g1-small"

    tags = []
  }
}

# The following outputs allow authentication and connectivity to the Google Container Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}

resource "google_compute_disk" "mysql-disk" {
  name  = "mysql-disk"
  type  = "pd-standard"
  zone  = "asia-northeast1-a"
}