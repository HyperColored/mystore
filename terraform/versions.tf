terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.94"
    }
  }

backend "s3" {
  endpoint   = "storage.yandexcloud.net"
  bucket     = "terraform"
  region     = "ru-central1"
  key        = "terraform.tfstate"

  skip_region_validation      = true
  skip_credentials_validation = true
  }

  required_version = ">= 1.4.0"
}
