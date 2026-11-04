project_id      = "bayu-project-502304"
region          = "us-central1"
# zone            = "us-central1-a"

# # ==============================================================================


# labels = {
#   environment = "dev"
#   owner       = "tim-backend"
#   managed_by  = "terraform"
# }
# boot_disk_labels = {
#     label_key = "value"
# }

existing_subnet_name = "subnet-site-a" # Sesuaikan dengan nama Subnet Anda di GCP
# # ==============================================

# KONFIGURASI COMPUTE ENGINE
vms = {
  # VM ini butuh konfigurasi yang sangat custom
  "lms-staging" = {
    zone         = "us-central1-a"
    machine_type = "e2-medium"
    boot_disk_image = "ubuntu-os-cloud/ubuntu-minimal-2610-amd64"    
    boot_disk_size      = 30
    # desired_status = "TERMINATED"
    assign_external_ip = true
    network_tags = ["http-https"]
    
  }
}


# ==============================================
# KONFIGURASI CLOUD STORAGE
buckets = {
  "porto-staging-bucket" = {
    location      = "us-central1"
    storage_class = "STANDARD"
    versioning_enabled = true
    labels = {
      environment   = "staging"
      data_type     = "pdf-materials"
      managed_by    = "terraform"
      project_type  = "porto"
      apps          = "lms"
    }
  }
}


# ========================================================================
