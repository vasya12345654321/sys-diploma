resource "yandex_compute_instance" "web_a" {
  name        = "web-a"
  hostname    = "web-a"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    ssh-keys       = "ubuntu:${var.ssh_public_key}"
    enable-oslogin = "false"
  }

  scheduling_policy {
    preemptible = false
  }
}


resource "yandex_compute_instance" "web_b" {
  name        = "web-b"
  hostname    = "web-b"
  zone        = "ru-central1-b"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_b.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    ssh-keys       = "ubuntu:${var.ssh_public_key}"
    enable-oslogin = "false"
  }

  scheduling_policy {
    preemptible = false
  }
}


resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  hostname    = "bastion"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.bastion.id]
  }

  metadata = {
    ssh-keys       = "ubuntu:${var.ssh_public_key}"
    enable-oslogin = "false"
  }

  scheduling_policy {
    preemptible = false
  }
}


resource "yandex_compute_instance" "zabbix" {
  name        = "zabbix"
  hostname    = "zabbix"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.monitoring.id]
  }

  metadata = {
    ssh-keys = <<-EOT
      ubuntu:${var.ssh_public_key}
      ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXFdcFmMFCHm8Xy9Kj94IBaVx/GwELaAr9ULh2V5Yk7 ubuntu@bastion
    EOT

    enable-oslogin     = "false"
    serial-port-enable = "1"
  }

  scheduling_policy {
    preemptible = false
  }
}


resource "yandex_compute_instance" "elasticsearch" {
  name        = "elasticsearch"
  hostname    = "elasticsearch"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private_a.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.logging.id]
  }

  metadata = {
    ssh-keys       = "ubuntu:${var.ssh_public_key}"
    enable-oslogin = "false"
  }

  scheduling_policy {
    preemptible = false
  }
}


resource "yandex_compute_instance" "kibana" {
  name        = "kibana"
  hostname    = "kibana"
  zone        = "ru-central1-a"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd806c8slu9j1pa87msc"
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public_a.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.logging.id]
  }

  metadata = {
    ssh-keys       = "ubuntu:${var.ssh_public_key}"
    enable-oslogin = "false"
  }

  scheduling_policy {
    preemptible = false
  }
}
