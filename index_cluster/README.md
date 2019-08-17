# index_cluster

This plan will by default create:

- 1x Splunk instance configured to be an index cluster master
- 3x Splunk instances configured as indexers, in two sites (2 in site1 and 1 in site2)

Some setup for your environment will be required - you can configure this by overriding the variables in `vars.tf` - either as environment variables, or by placing them in `terraform.tfvars`. This will vary by provider - a further README in each provider's folder will list the minimum required configuration.

You can also deploy Splunk apps automatically to all spawned indexers by placing the archive (`.tar`, `.tgz`, `.tar.gz`, or `.spl`) for the individual apps in `files/icm/master-apps/`.
