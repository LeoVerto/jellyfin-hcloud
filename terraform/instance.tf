resource "hcloud_server" "server" {
  name        = "jellyfin-${local.name}"
  image       = "debian-10"
  server_type = var.server_type
  location    = var.location
  backups     = "false"
  ssh_keys    = [hcloud_ssh_key.user.id]

  # Dummy provisioner toe ensure the server is up before we run they playbook
  provisioner "remote-exec" {
    inline = ["touch kilroy.txt", "echo Done!"]

    connection {
      host = self.ipv4_address
      type = "ssh"
      user = "root"
    }
  }

  provisioner "local-exec" {
    working_dir = "${path.cwd}/../ansible"
    environment = {
      HCLOUD_TOKEN        = var.hcloud_token
      ANSIBLE_FORCE_COLOR = true
    }
    command = <<-EOF
      ansible-galaxy install -r requirements.yml
      ansible-playbook -i hcloud.yml -e 'ansible_python_interpreter=/usr/bin/python3' --extra-vars="dns_fullname=${var.dns_fullname}" setup-jellyfin.yml
      EOF
  }

  provisioner "local-exec" {
    command = "echo Done! You can now connect to the server via ssh://deploy@${var.dns_fullname} or ssh://deploy@${self.ipv4_address}."
  }

  # Remove IP from SSH known_hosts
  provisioner "local-exec" {
    when    = destroy
    command = "ssh-keygen -R ${self.ipv4_address}"
  }
}

resource "hcloud_ssh_key" "user" {
  name       = "user"
  public_key = var.public_key
}
