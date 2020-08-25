variable "vm_count" {
  type    = number
}

provider "proxmox" {
    pm_api_url = "https://##your_ip/api2/json"
    pm_password = "##your_password"
    pm_user = "packer@pve"
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = var.vm_count
  name              = "tf-vm-${count.index}"
  target_node       = "pve"
  clone             = "ubuntu-18-04"
  os_type           = "cloud-init"
  cores             = 2
  sockets           = "1"
  agent = 1
  cpu               = "host"
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  clone_wait        = 120
  ci_wait           = 10
  onboot            = false
  disk {
    id              = 0
    size            = 32
    type            = "scsi"
    storage         = "local-lvm"
    storage_type    = "lvm"
    iothread        = true
  }
  network {
    id              = 0
    model           = "virtio"
    bridge          = "vmbr0"
  }
  lifecycle {
    ignore_changes  = [
      network,
    ]
  }

  # Cloud Init Settings
  # Pour deux machines, les adresses seront 192.168.1.81 et 192.168.1.82
  # Attention il faut s'assurer que la plage d'adresse est disponible
  ipconfig0 = "ip=192.168.1.8${count.index + 1}/24,gw=192.168.1.1"
}


