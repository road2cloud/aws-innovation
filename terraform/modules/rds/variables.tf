variable "RDS_PASSWORD" {
  default = "YourPwdShouldBeLongAndSecure!"
}

variable "database_identifier" {
  default = "labarc"
}

variable "private_subnet1_id" {}

variable "private_subnet2_id" {}

#variable "public_sg" {}

variable "vpc_id" {}

variable "instance_type" {
  default = "db.t2.small"
}

/*variable "alarm_actions" {
  type = "list"
}

variable "ok_actions" {
  type = "list"
}

variable "insufficient_data_actions" {
  type = "list"
}*/

variable "alarm_cpu_threshold" {
  default = "75"
}

variable "alarm_disk_queue_threshold" {
  default = "10"
}

variable "alarm_free_disk_threshold" {
  # 5GB
  default = "5000000000"
}

variable "alarm_free_memory_threshold" {
  # 128MB
  default = "128000000"
}
