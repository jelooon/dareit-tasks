provider "google" {
  project     = "kubernetes-project-383412"
  region      = "us-central1"
}

resource "google_storage_bucket" "static-site" {
  name          = "my-static-bucket"
  location      = "US"
  force_destroy = true

 uniform_bucket_level_access = false

  website {
    main_page_suffix = "main.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
resource "google_storage_bucket_object" "static_site_src" {
  name   = "main.html"
  source = "/home/username/terraform/main.html"
  bucket = "my-static-bucket"
}
resource "google_storage_default_object_access_control" "public_rule" {
  bucket = "my-static-bucket"
  role   = "READER"
  entity = "allUsers"
}
