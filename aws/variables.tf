#   __      __        _       _     _           
#   \ \    / /       (_)     | |   | |          
#    \ \  / /_ _ _ __ _  __ _| |__ | | ___  ___ 
#     \ \/ / _` | '__| |/ _` | '_ \| |/ _ \/ __|
#      \  / (_| | |  | | (_| | |_) | |  __/\__ \
#       \/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
#                                             

# Expect both of these to be in 'terraform.tfvars' file.

variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "eu-west-2" # London
}

variable "storage_availability_zone" {
  default = "eu-west-2a" # London
}

variable "worker_storage_size" {
  default = 20 # In GiBs
}

variable "postgresql_storage_size" {
  default = 10 # In GiBs
}

variable "name" {
  default = "concourse"
}

variable "cluster_name" {
  default = "cluster"
}

variable "domain" {
  default = "morsley.io"
}