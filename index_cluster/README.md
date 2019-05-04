# index_cluster

This plan will by default create:

- 1x Splunk instance configured to be an index cluster master
- 3x Splunk instances configured as indexers, in two sites (2 in site1 and 1 in site2)

These instances will be created in the AMS3 DigitalOcean region, and will be 1 vCPU x 1GB droplets.

This and more can be configured by overriding the variables in [vars.tf](./vars.tf) - either as environment variables, or by placing them in `terraform.tfvars`.
