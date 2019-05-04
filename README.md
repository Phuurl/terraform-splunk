# ⛰ terraform-splunk [![Build Status](https://travis-ci.com/Phuurl/terraform-splunk.svg?branch=master)](https://travis-ci.com/Phuurl/terraform-splunk)

A Terraform plan to set up a Splunk cluster in the cloud for testing purposes.

## Current provider support

- DigitalOcean
- ~~Google Cloud Platform~~ (coming soon - [#10](/../../issues/10))

## Requirements

- [Terraform](https://www.terraform.io/downloads.html)
- Ansible (install through your package manager or pip)
- A DigitalOcean account ([referral link for free credit](https://m.do.co/c/79ec1acd556c))
- Python (tested on 3.7 and 2.7, but will likely work in pretty much all versions)

## Usage

1. Clone the repo, then `cd` into the directory for the appropriate plan
2. `cp terraform.tfvars.exmaple terraform.tfvars`, then add your provider key and the password you wish to be set across the Splunk cluster. Also look in `vars.tf` to check you are happy with the default values - overriding in `terraform.tfvars` where required
3. `terraform init` to download and set up the required providers
4. `terraform apply` to begin creating the instances
5. When you're finished with the cluster, run `terraform destroy`

## Contributing

Pull requests are welcome - please ensure that you update any READMEs and Travis tests where required
