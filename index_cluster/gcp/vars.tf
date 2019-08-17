# DigitalOcean settings

# Google Cloud Platform settings
variable "gcp_project" {}
variable "gcp_region" {
  default = "europe-west1"
}
variable "gcp_zone" {
  default = "europe-west1-d"
}
variable "gcp_image_name" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}
variable "gcp_size" {
  default = "g1-small"
}
variable "gcp_ssh_user" {}

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
