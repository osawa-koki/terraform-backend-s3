
variable "project_name" {
  type = string
  description = "Name of the project."
}

variable "ssh_public_key_path" {
  type = string
  default = "~/.ssh/id_rsa.pub"
  description = "Path to the public key."
}

variable "allowed_ip_addresses" {
  type = list(string)
  description = "IP addresses allowed to access the instance."
}
