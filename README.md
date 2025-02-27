# PiCluster
GitOps approach to managing the infrastructure for my Raspberry Pi Kubernetes cluster using a traditional `push` (CI/CD) model.
- Built with:
  - Ansible: for automation.
  - Tailscale: for managing network access.
  - GitHub Actions: for CI/CD.

Workflows are idempotent so can be rerun on existing hardware without risk of breakage.

I am running this on Raspberry Pi 4's with Ubuntu 24.04 LTS, however in theory it should work on any devices running a Debian based OS.

## Setup
1. [Setup a tailnet](https://tailscale.com/kb/1017/install) if you haven't already.
2. Navigate to your [machines](https://login.tailscale.com/admin/machines) and goto `Settings -> Keys -> Generate auth key...`.
3. Give the key a memorable description (eg. "github-runner"), and activate `Reusable` (this means you won't have to setup a new key each time you run the playbooks) and `Ephemeral` (this will remove any machines created with this key after they have been offline for a period of time, keeping your machine list tidy). Then click `Generate key`.
4. Take note of the generated key, this is the only time you will see it in full.
5. Fork this repo, then in `Settings -> Secrets and varaibles -> Actions` click `New repository secret`, call it `TAILSCALE_AUTHKEY` and past in the key you just generated.
6. Install Tailscale on each new node, and add it to the tailnet by running:
```shell
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```
7. On your local machine generate an SSH keypair by running `ssh-keygen` (Mac/Linux), this will create two key files in your home directories `.ssh` sub-directory.
8. Copy the private key file (the one without a `.pub` extension), and navigate to `Settings -> Secrets and varaibles -> Actions` in your repo and click `New repository secret`. Call it `SSH_PRIVATE_KEY`.
9. Copy the public key file to each node device, if you have SSH access from the machine where you generated the file, you can do this with `ssh-copy-id <username>@>hostname>`, otherwise on the node itself, open `~/.ssh/authorized_keys` and paste the key on a new line.
10. On each new node, run `echo "piadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/piadmin`, this allows the workflow sudo access without having to store the password in the repo.

For each new node you add to the cluster, run steps 6, 9 and 10. These can be added anytime, not just during initial setup.

## Usage
Navigate to `Actions -> Ansible Deploy` in your repo. If you haven't already, enable GitHub actions for your repo. Now Click `Run workflow`.

The workflow uses a manual `workflow_dispatch` trigger so you can freely make changes to the codebase without triggering the playbook.
