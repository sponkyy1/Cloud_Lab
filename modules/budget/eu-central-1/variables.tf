variable "subscriber_email_addresses" {
  type = list(string)
}

variable "slack_webhook_url" {
  type = string
  // default = "https://hooks.slack.com/services/AAA/BBB/CCC"
}

variable "author_name" {
  type = string
  default = "Pan Yurii"
}