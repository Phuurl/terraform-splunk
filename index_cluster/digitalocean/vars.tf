# DigitalOcean settings
variable "do_token" {}
variable "do_image_name" {
  default = "ubuntu-18-04-x64"
}
variable "do_region" {
  default = "AMS3"
}
variable "do_size" {
  default = "s-1vcpu-1gb"
}

# Path to your public SSH key
variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

# Prefix used for naming machines
variable "prefix" {
  default = "splunk-terraform"
}

# URL for required Splunk tar
variable "splunk_download" {
  default = "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.2.6&product=splunk&filename=splunk-7.2.6-c0bf0f679ce9-Linux-x86_64.tgz&wget=true"
}

# Splunk password and pass4SymmKey
variable "splunk_password" {}

# Number of indexers to be spawned
variable "num_indexers" {
  default = 3
}

# Number of Splunk sites to be configured
variable "num_sites" {
  default = 2
}
