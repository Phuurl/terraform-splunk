# ⛰ terraform-splunk [![Build Status](https://travis-ci.com/Phuurl/terraform-splunk.svg?branch=master)](https://travis-ci.com/Phuurl/terraform-splunk)

A Terraform plan to set up a Splunk cluster in the cloud for testing purposes.

## Current provider support

- DigitalOcean
- Google Cloud Platform

## Requirements

- [Terraform](https://www.terraform.io/downloads.html)
- Ansible (install through your package manager or pip)
- A DigitalOcean account ([referral link for free credit](https://m.do.co/c/79ec1acd556c)) or GCP project
- Python (tested on 3.7 and 2.7, but will likely work in all versions that Ansible supports)

## Usage

1. Clone the repo, then `cd` into the directory for the appropriate plan and cloud provider
2. `cp terraform.tfvars.exmaple terraform.tfvars`, then add your provider key and the password you wish to be set across the Splunk cluster. Also look in `vars.tf` to check you are happy with the default values - overriding in `terraform.tfvars` where required
3. `terraform init` to download and set up the required providers
4. `terraform apply` to begin creating the instances
5. Once complete, instance information (such as IPs) can be viewed with `terraform show`
6. When you're finished with the cluster, run `terraform destroy` to delete the created resources

## Contributing

Pull requests are welcome - please ensure that you update any READMEs and Travis tests where required
