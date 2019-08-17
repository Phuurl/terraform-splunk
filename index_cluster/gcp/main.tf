provider "google" {
  project = "${var.gcp_project}"
  region  = "${var.gcp_region}"
  zone    = "${var.gcp_zone}"
}

data "http" "client_ip" {
  url = "https://ifconfig.co"
}

resource "google_compute_instance" "icm" {
  name = "${var.prefix}-icm"
  machine_type = "${var.gcp_size}"
  tags = ["icm"]
  boot_disk {
    initialize_params {
      image = "${var.gcp_image_name}"
    }
  }
  network_interface {
    network = "${google_compute_network.vpc.self_link}"
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(pathexpand(var.ssh_key_path))}"
  }
  provisioner "local-exec" {
    command = "sleep 30; echo '${self.network_interface.0.access_config.0.nat_ip } ansible_python_interpreter=/usr/bin/python3' > ../ansible/icm_host; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '../ansible/icm_host' -e 'prefix=${var.prefix}' -e sites_string=$(python ../ansible/sites_string.py icm ${var.num_sites}) -e 'splunk_password=${var.splunk_password}' -e 'splunk_download=${var.splunk_download}' ../ansible/master.yml -t icm"
  }
}

resource "google_compute_instance" "idx" {
  name = "${var.prefix}-idx-${count.index}"
  machine_type = "${var.gcp_size}"
  tags = ["idx"]
  count = "${var.num_indexers}"
  boot_disk {
    initialize_params {
      image = "${var.gcp_image_name}"
    }
  }
  network_interface {
    network = "${google_compute_network.vpc.self_link}"
    access_config {
    }
  }
  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(pathexpand(var.ssh_key_path))}"
  }
  provisioner "local-exec" {
    command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.network_interface.0.access_config.0.nat_ip },' -e 'ansible_python_interpreter=/usr/bin/python3' -e 'prefix=${var.prefix}' -e sites_string=$(python ../ansible/sites_string.py idx ${var.num_indexers} ${var.num_sites} ${count.index + 1}) -e 'splunk_password=${var.splunk_password}' -e 'idx_num=${count.index + 1}' -e 'icm_ip=${google_compute_instance.icm.network_interface.0.network_ip }' -e 'splunk_download=${var.splunk_download}' ../ansible/master.yml -t idx"
  }
}

resource "google_compute_firewall" "external" {
  name = "${var.prefix}-external-firewall"
  network = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["22", "8000"]
  }

  # Set to be accessible from your current external IP only - switch if this is expected to change
  source_ranges = ["${chomp(data.http.client_ip.body)}/32"]
}

resource "google_compute_firewall" "internal" {
  name = "${var.prefix}-internal-firewall"
  network = "${google_compute_network.vpc.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = ["8080", "8089", "8191", "9997"]
  }

  # Default internal VOC range
  source_ranges = ["10.128.0.0/9"]
}

resource "google_compute_network" "vpc" {
  name = "${var.prefix}-network"
  auto_create_subnetworks = "true"
}
