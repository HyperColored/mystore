resource "yandex_kms_symmetric_key" "kms-key" {
  name              = var.kms_key_name
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год
}
