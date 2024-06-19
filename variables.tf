variable "application_name" {
  type = string
}

variable "environment_name" {
  type = string
}

variable "admin_users" {
  type = list(string)
}

variable "reader_users" {
  type = list(string)
}

variable "group_owners" {
  type = list(string)
}