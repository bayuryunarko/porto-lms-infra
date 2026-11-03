# ========================================================================
# 1. BLOK TERRAFORM BACKEND (Sang Penjaga State)
# ========================================================================
terraform {
  backend "gcs" {
    bucket = "porto-tf-bucket"      # Ganti dengan nama bucket manual Anda
    prefix = "terraform/staging/resource"
  }
}


# ========================================================================
# 2. DEKLARASI VARIABEL
# ========================================================================
variable "project_id" {}
variable "region" {}
variable "existing_subnet_name" {}
# variable "cloudsql" {}
variable "buckets" {}
# variable "redis_instances" {}
# variable "gke_clusters" {}


# ========================================================================
# 3. BLOK PROVIDER
# ========================================================================
provider "google" {
  project = var.project_id
  region = var.region
}

# ========================================================================
# 4. DATA SOURCE (VPC EKSISTING)
# ========================================================================
data "google_compute_subnetwork" "app_subnet" {
  # Masukkan nama subnet secara langsung atau via variabel
  name   = var.existing_subnet_name 
  region = var.region
}


# # ========================================================================
# # 5. PEMANGGILAN MODUL (Dari GitHub Repository Anda)
# # ========================================================================
# # Panggil modul Compute Engine
# module "compute" {
#   source   = "git::https://github.com/bayuryunarko/porto-terraform-modules.git//apps/modules/compute?ref=main"
  
#   for_each = var.vms

#   # Nama VM diambil dari kunci ("web-server-01", "db-server-01")
#   vm_name = each.key 

#   # INJEKSI JARINGAN OTOMATIS: 
#   # Semua VM akan otomatis masuk ke subnet yang dicari oleh blok data di atas.
#   # Anda tidak perlu lagi menulis subnet_id di dalam file .tfvars!
#   subnet_id = data.google_compute_subnetwork.app_subnet.id
  
#   # Mapping sisa parameternya
#   zone                        = each.value.zone
#   machine_type                = each.value.machine_type
#   desired_status              = each.value.desired_status
#   deletion_protection         = each.value.deletion_protection
#   assign_external_ip          = each.value.assign_external_ip
#   network_tier                = each.value.network_tier
#   network_tags                = each.value.network_tags
#   hostname                    = each.value.hostname
#   boot_disk_image             = each.value.boot_disk_image
#   boot_disk_type              = each.value.boot_disk_type
#   boot_disk_size              = each.value.boot_disk_size
#   boot_disk_labels            = each.value.boot_disk_labels
#   additional_disks            = each.value.additional_disks
#   enable_secure_boot          = each.value.enable_secure_boot
#   enable_vtpm                 = each.value.enable_vtpm
#   enable_integrity_monitoring = each.value.enable_integrity_monitoring
#   enable_oslogin              = each.value.enable_oslogin
#   enable_oslogin_2fa          = each.value.enable_oslogin_2fa
#   block_project_ssh_keys      = each.value.block_project_ssh_keys
#   ssh_keys                    = each.value.ssh_keys
#   service_account_email       = each.value.service_account_email
#   access_scopes               = each.value.access_scopes
#   labels                      = each.value.labels
#   install_ops_agent           = each.value.install_ops_agent
#   custom_metadata             = each.value.custom_metadata
#   startup_script              = each.value.startup_script
# }

# # ========================================================================

# # Panggil modul Cloud Storage
# module "cloud_storage" {
#   # Pastikan path ini sesuai dengan letak folder modul Anda
#   source = "git::https://github.com/bayuryunarko/porto-terraform-modules.git//apps/modules/cloud-storage?ref=main"
  
#   buckets = var.buckets
# }

# # ========================================================================
