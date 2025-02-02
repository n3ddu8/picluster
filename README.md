# PiCluster
Ansible Playbooks for Managing my PiCluster Infrastructure

## Tailscale
Add the node to tailnet:
```shell
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt update
sudo apt install tailscale -y
sudo tailscale up
```

## SSH
SSH access needs to be setup from the environment running the Ansible Playbook to each of potential nodes on the cluster:
```shell
ssh-keygen
ssh-copy-id <username>@<hostname>
```
Configure the relevant details in `inventory.yaml` for each node:
```yaml
ansible_host:
ansible_user:
ansible_become:
ansible_become_password:
```
You can test the connectivity by running:
```shell
ansible -i inventory.yaml all -m ping
```

## Usage
```shell
ansible-playbook -i inventory.yaml playbook.yaml
```
