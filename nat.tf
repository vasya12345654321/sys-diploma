resource "yandex_vpc_gateway" "nat_gateway" {
  name = "diploma-nat-gateway"

  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.diploma.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}