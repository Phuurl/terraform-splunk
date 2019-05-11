provider "digitalocean" {
  token = "${var.do_token}"
}

data "http" "client_ip" {
  url = "https://ifconfig.co"
}

resource "digitalocean_ssh_key" "default" {
  name = "${var.prefix}-key"
  public_key = "${file(pathexpand(var.ssh_key_path))}"
}

resource "digitalocean_tag" "icm" {
  name = "icm"
}

resource "digitalocean_tag" "idx" {
  name = "idx"
}

resource "digitalocean_droplet" "icm" {
  image = "${var.do_image_name}"
  name = "${var.prefix}-icm"
  region = "${var.do_region}"
  size = "${var.do_size}"
  private_networking = true
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
  tags = ["${digitalocean_tag.icm.id}"]
  provisioner "local-exec" {
    command = "sleep 30; echo '${self.ipv4_address} ansible_python_interpreter=/usr/bin/python3' > ../ansible/icm_host; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '../ansible/icm_host' -e 'prefix=${var.prefix}' -e sites_string=$(python ../ansible/sites_string.py icm ${var.num_sites}) -e 'splunk_password=${var.splunk_password}' -e 'splunk_download=${var.splunk_download}' ../ansible/master.yml -t icm"
  }
}

resource "digitalocean_droplet" "idx" {
  image = "${var.do_image_name}"
  name = "${var.prefix}-idx-${count.index}"
  region = "${var.do_region}"
  size = "${var.do_size}"
  count = "${var.num_indexers}"
  private_networking = true
  ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
  tags = ["${digitalocean_tag.idx.id}"]
  provisioner "local-exec" {
    command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' -e 'ansible_python_interpreter=/usr/bin/python3' -e 'prefix=${var.prefix}' -e sites_string=$(python ../ansible/sites_string.py idx ${var.num_indexers} ${var.num_sites} ${count.index + 1}) -e 'splunk_password=${var.splunk_password}' -e 'idx_num=${count.index + 1}' -e 'icm_ip=${digitalocean_droplet.icm.ipv4_address_private}' -e 'splunk_download=${var.splunk_download}' ../ansible/master.yml -t idx"
  }
}

resource "digitalocean_firewall" "icm" {
  name = "${var.prefix}-icm"
  tags = ["${digitalocean_tag.icm.name}"]
  inbound_rule {
      protocol = "icmp"
      source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    # Set to be accessible from your current external IP only - switch if this is expected to change
    source_addresses = ["${chomp(data.http.client_ip.body)}/32"]
    # source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "8000"
    # Set to be accessible from your current external IP only - switch if this is expected to change
    source_addresses = ["${chomp(data.http.client_ip.body)}/32"]
    # source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "8080"
    source_tags = ["${digitalocean_tag.idx.name}"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "8089"
    source_tags = ["${digitalocean_tag.idx.name}"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "8191"
    source_tags = ["${digitalocean_tag.idx.name}"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "9997"
    source_tags = ["${digitalocean_tag.idx.name}"]
  }
  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "idx" {
  name = "${var.prefix}-idx"
  tags = ["${digitalocean_tag.idx.name}"]
  inbound_rule {
      protocol = "icmp"
      source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "22"
    # Set to be accessible from your current external IP only - switch if this is expected to change
    source_addresses = ["${chomp(data.http.client_ip.body)}/32"]
    # source_addresses = ["0.0.0.0/0", "::/0"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "8080"
    source_tags = ["${digitalocean_tag.idx.name}", "${digitalocean_tag.icm.name}"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "8089"
    source_tags = ["${digitalocean_tag.idx.name}", "${digitalocean_tag.icm.name}"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "8191"
    source_tags = ["${digitalocean_tag.idx.name}", "${digitalocean_tag.icm.name}"]
  }
  inbound_rule {
    protocol = "tcp"
    port_range = "9997"
    source_tags = ["${digitalocean_tag.idx.name}", "${digitalocean_tag.icm.name}"]
  }
  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
