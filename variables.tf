variable "organization_name" {
  description = "(Required) Your organization's name"
}

variable "distribution_list_email_address" {
  description = "(Required) The distribution list to send cat facts to."
}

variable "location" {
  description = "(Optional) Which Azure location to launch Cat Facts in."
  default     = "canadacentral"
}

variable "city" {
  description = "(Required) Your city"
}

variable "your_name" {
  description = "(Optional) Your name"
  default     = "A kind stranger"
}

variable "boss_name" {
  description = "(Optional) Your boss' name"
  default     = "Someone who cares"
}

variable "sleep_time" {
  description = "(Optional) How long do you need to go connect this workflow app to an O365 account for sending email."
  default     = "60"
}
