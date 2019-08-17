# DigitalOcean

For DigitalOcean, the following parameters are required (as listed in [terraform.tfvars.example](./terraform.tfvars.example)):

- `do_token` - your personal DigitalOcean account token. See the [DigitalOcean documentation](https://www.digitalocean.com/docs/api/create-personal-access-token/) for how to create one.
- `splunk_password` - the password used for the `admin` account on the created Splunk instances.
