provider "google" {

  project = "testowy-378118"

  region  = "us-central1"

  zone    = "us-central1-c"

}

resource "google_storage_bucket" "static-site" {
  name          = "dare-it"

  location      = "EU"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}


resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.static-site.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
variable "project_id" {
  description = "Google Project ID."
  type        = string
}
variable "bucket_name" {
  description = "GCS Bucket name. Value should be unique."
  type        = string
}
output "url" {
  description = "Website URL"
  value       = google_storage_bucket.static-site.self_link
}


resource "google_compute_instance" "dare-id-vm" {

  name         = "dareit-vm-tf"

  machine_type = "e2-medium"

  zone         = "us-central1-a"



  tags = ["dareit"]



  boot_disk {

    initialize_params {

      image = "debian-cloud/debian-11"

      labels = {

        managed_by_terraform = "true"

      }

    }

  }



  network_interface {

    network = "default"



    access_config {

      // Ephemeral public IP

    }

  }

}


resource "google_sql_database_instance" "dareit" {
  name             = "dareit"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  name     = "dareit-user"
  password = "DareIT"
  instance = "${google_sql_database_instance.dareit.name}"
}
