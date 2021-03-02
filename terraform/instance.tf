resource "hcloud_server" "server" {
    name = "jellyfin-${local.name}"
    image = "debian-10"
    server_type = "cx11"
    location = "nbg1"
    backups = "false"
    ssh_keys = [hcloud_ssh_key.user.id]

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
            HCLOUD_TOKEN = var.hcloud_token
        }
        command = <<-EOF
        ansible-galaxy install -r requirements.yml
        ansible-playbook -i hcloud.yml -e 'ansible_python_interpreter=/usr/bin/python3' setup-jellyfin.yml
        EOF
    }
}

resource "hcloud_ssh_key" "user" {
    name = "user"
    public_key = var.public_key
}
