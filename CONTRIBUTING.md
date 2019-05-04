# Contributing

Please be aware that for all new releases and contributions, we target the latest version of all platforms used - this includes:

- Latest stable release of Terraform and all providers used
- Latest stable release of Ansible and Python
- Latest Ubuntu LTS base image available on the target cloud platform

The default Splunk version string is currently hardcoded, but will be updated to the latest release available whenever there is a release of terraform-splunk. If a new version of Splunk is released that is not compatible with terraform-splunk, please open an issue on this project and we will get it fixed.

Where there are breaking changes in new versions of the platforms and tools, the latest version should still be used, but backward compatible code is strongly preferred where possible.
