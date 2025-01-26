# PiCluster
Ansible Playbooks for Managing my PiCluster Infrastructure

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
