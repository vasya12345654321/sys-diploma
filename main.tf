terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.170"
    }
  }

  required_version = ">= 1.15.0"
}

provider "yandex" {
}
