variable "vms" {
  description = "Peta konfigurasi untuk memprovisikan banyak VM"
  type = map(object({
    # =====================================================================
    # PARAMETER WAJIB (Harus selalu ditulis di .tfvars)
    # =====================================================================
    zone         = string
    machine_type = string

    # =====================================================================
    # PARAMETER OPSIONAL (Tidak wajib ditulis, akan otomatis pakai default)
    # =====================================================================
    desired_status      = optional(string, "RUNNING")
    deletion_protection = optional(bool, false)

    # --- Networking ---
    assign_external_ip = optional(bool, false)
    network_tier       = optional(string, "PREMIUM")
    network_tags       = optional(list(string), [])
    hostname           = optional(string, null)

    # --- Storage ---
    boot_disk_image  = optional(string, "ubuntu-os-cloud/ubuntu-2204-lts")
    boot_disk_type   = optional(string, "pd-standard")
    boot_disk_size   = optional(number, 10)
    boot_disk_labels = optional(map(string), {})
    
    additional_disks = optional(map(object({
      type   = string
      size   = number
      labels = optional(map(string), {})
    })), {})

    # --- Shielded VM ---
    enable_secure_boot          = optional(bool, false)
    enable_vtpm                 = optional(bool, true)
    enable_integrity_monitoring = optional(bool, true)

    # --- Access & OS Login ---
    enable_oslogin         = optional(bool, true)
    enable_oslogin_2fa     = optional(bool, false)
    block_project_ssh_keys = optional(bool, true)
    ssh_keys               = optional(string, null)

    # --- Service Account & Scopes ---
    service_account_email = optional(string, null)
    access_scopes         = optional(list(string), ["https://www.googleapis.com/auth/cloud-platform"])

    # --- Observability, Labels & Metadata ---
    labels            = optional(map(string), {})
    install_ops_agent = optional(string, "TRUE")
    custom_metadata   = optional(map(string), {})
    startup_script    = optional(string, null)
  }))
  default = {}
}