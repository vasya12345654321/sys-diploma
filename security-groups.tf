resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.diploma.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Zabbix agent"
    port           = 10050
    v4_cidr_blocks = ["10.10.1.21/32"]
  }

  egress {
    protocol       = "ANY"
    description    = "All outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "web" {
  name       = "web-sg"
  network_id = yandex_vpc_network.diploma.id

  ingress {
    protocol          = "TCP"
    description       = "HTTP from load balancer"
    port              = 80
    security_group_id = yandex_vpc_security_group.load_balancer.id
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol          = "TCP"
    description       = "Zabbix agent"
    port              = 10050
    security_group_id = yandex_vpc_security_group.monitoring.id
  }

  egress {
    protocol       = "ANY"
    description    = "All outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "load_balancer" {
  name       = "load-balancer-sg"
  network_id = yandex_vpc_network.diploma.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "Load balancer health checks"
    port              = 30080
    predefined_target = "loadbalancer_healthchecks"
  }

  egress {
    protocol       = "ANY"
    description    = "All outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "monitoring" {
  name       = "monitoring-sg"
  network_id = yandex_vpc_network.diploma.id

  ingress {
    protocol       = "TCP"
    description    = "Zabbix web interface"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Zabbix server"
    port           = 10051
    v4_cidr_blocks = ["10.10.0.0/16"]
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  egress {
    protocol       = "ANY"
    description    = "All outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "logging" {
  name       = "logging-sg"
  network_id = yandex_vpc_network.diploma.id

  ingress {
    protocol       = "TCP"
    description    = "Elasticsearch"
    port           = 9200
    v4_cidr_blocks = ["10.10.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Kibana"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol          = "TCP"
    description       = "Zabbix agent"
    port              = 10050
    security_group_id = yandex_vpc_security_group.monitoring.id
  }

  egress {
    protocol       = "ANY"
    description    = "All outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}