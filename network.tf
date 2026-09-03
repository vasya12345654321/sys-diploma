resource "yandex_vpc_network" "diploma" {
  name = "diploma-network"
}

resource "yandex_vpc_subnet" "public_a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diploma.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "public_b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.diploma.id
  v4_cidr_blocks = ["10.10.2.0/24"]
}

resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diploma.id
  route_table_id = yandex_vpc_route_table.private.id
  v4_cidr_blocks = ["10.10.3.0/24"]
}

resource "yandex_vpc_subnet" "private_b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.diploma.id
  route_table_id = yandex_vpc_route_table.private.id
  v4_cidr_blocks = ["10.10.4.0/24"]
}