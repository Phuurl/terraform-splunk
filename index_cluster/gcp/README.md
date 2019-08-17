# Google Cloud Platform

For GCP, the following parameters are required (as listed in [terraform.tfvars.example](./terraform.tfvars.example)):

- `gcp_project` - your GCP project ID. More information can be found in the [GCP documentation](https://cloud.google.com/resource-manager/docs/creating-managing-projects).
- `gpc_ssh_user` - the username of your SSH key. This will most likely be the username of the currently logged in user.
- `splunk_password` - the password used for the `admin` account on the created Splunk instances.

## Additional setup

Before you can run the Terraform plan, you will need to authenticate with GCP.

1. Download, install, and configure the `gcloud` command line utilities - see the [Google Cloud SDK quickstart docs](https://cloud.google.com/sdk/docs/quickstarts) for more information.
2. Run `gcloud auth application-default login` to create the local credentials to allow Terraform access.
