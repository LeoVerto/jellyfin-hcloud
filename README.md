# Automatically set up Jellyfin on Hetzner Cloud using Terraform and Ansible
This reposistory provides both an Ansible playbook to automatically
install Jellyfin on a Debian server as well as
a Terraform configuration to provision a server at Hetzer Cloud,
run the playbook, and set up DNS records.

Jellyfin is set up using the official Docker image with
Traefik as a reverse proxy for TLS termination.

The playbook handles some basic hardening of the server using
roles from [https://github.com/dev-sec/ansible-collection-hardening/](dev-sec/ansible-collection-hardening).
The SSH server is configured to a standard similar to the
[Mozilla Modern guideline](https://infosec.mozilla.org/guidelines/openssh).
The TLS configuration is rated as "A+" by [Qualys SSLLabs](https://ssllabs.com/).

As of the time of writing, the playbook is really only intended
to work with an existing Jellyfin config directory, see below for details and how to correctly use it.

## Requirements
You need to have ansible, terraform and python-hcloud installed.

If the latter isn't available as a package on your distribution, install it using `pip --user install python-hcloud`.

## Configuration
Enter the terraform directory and create a file `terraform.tfvars` defining all the required variables
from `variables.tf`.

If your media files can be directly played by all clients, a `cx11` instance should work fine,
but as soon as clients require transcoding, you will need a bigger instance.

Ideally you should use an instance with dedicated CPU resources.
The `ccx31` type should be sufficient for trancoding at least five different streams at the same time.

This playbook is intended to be used with an existing Jellyfin configuration.
Copy your Jellyfin `config` directory to `ansible/jellyfin-config`.

### **DANGER**

If you do not do this, the Jellyfin install wizard will be accessible
on the web and accessible by absolutely ***anyone***, who could then
create an admin account and use the server to server potentially
illegal content. You have been warned.

As a workaround you may change the Traefik config in `ansible/roles/jellyfin/templates`
to only allow local local connections until the wizard has been
completed.

If you figure out a better way to handle this, feel free to make a pull request.
I'd be happy to accept it!

## Running
Again in the `terraform` directory run `terraform apply`, enter "yes", and sit back and watch
as your server is being provisioned, hardened, and Jellyfin set up.

Once this is done you can connect to the server using the user name
`deploy` and upload media to `/srv/jellyfin/jellyfin/media`.
