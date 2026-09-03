resource "yandex_alb_target_group" "web" {
  name = "web-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.private_a.id
    ip_address = yandex_compute_instance.web_a.network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.private_b.id
    ip_address = yandex_compute_instance.web_b.network_interface[0].ip_address
  }
}


resource "yandex_alb_backend_group" "web" {
  name = "web-backend-group"

  http_backend {
    name             = "web-http-backend"
    port             = 80
    target_group_ids = [yandex_alb_target_group.web.id]

    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 2
      unhealthy_threshold = 3

      http_healthcheck {
        path = "/"
      }
    }
  }
}


resource "yandex_alb_http_router" "web" {
  name = "web-http-router"
}


resource "yandex_alb_virtual_host" "web" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web.id

  route {
    name = "web-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web.id
      }
    }
  }
}


resource "yandex_alb_load_balancer" "web" {
  name = "web-load-balancer"

  network_id = yandex_vpc_network.diploma.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public_a.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.public_b.id
    }
  }

  security_group_ids = [
    yandex_vpc_security_group.load_balancer.id
  ]

  listener {
    name = "http-listener"

    endpoint {
      address {
        external_ipv4_address {}
      }

      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.web.id
      }
    }
  }
}