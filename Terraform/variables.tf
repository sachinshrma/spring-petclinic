variable "prefix" {
  default = "prod"
}
variable "subscription_id" {
  
}
variable "client_id" {
  
}
variable "client_secret" {
  
}
variable "tenant_id" {
  
}
variable "location" {
  default = "westus"
}
output "public-ip" {
  value = ["${azurerm_public_ip.public-IP}"]
}
