provider "digitalocean" {
  token = "${var.do_token}"
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
    command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' -e 'ansible_python_interpreter=/usr/bin/python3' -e 'prefix=${var.prefix}' -e sites_string=$(python sites_string.py icm ${var.num_sites}) -e 'splunk_password=${var.splunk_password}' -e 'splunk_download=${var.splunk_download}' master.yml -t icm"
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
    command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' -e 'ansible_python_interpreter=/usr/bin/python3' -e 'prefix=${var.prefix}' -e sites_string=$(python sites_string.py idx ${var.num_indexers} ${var.num_sites} ${count.index + 1}) -e 'splunk_password=${var.splunk_password}' -e 'idx_num=${count.index + 1}' -e 'icm_ip=${digitalocean_droplet.icm.ipv4_address_private}' -e 'splunk_download=${var.splunk_download}' master.yml -t idx"
  }
}
