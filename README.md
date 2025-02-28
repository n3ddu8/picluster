# PiCluster
GitOps approach to managing the infrastructure for my Raspberry Pi K3S cluster using a traditional `push` (CI/CD) model.
- Built with:
  - Ansible: for automation.
  - Tailscale: for managing network access.
  - GitHub Actions: for CI/CD.

Workflows are idempotent so can be rerun on existing hardware without risk of breakage.

## Pre-requisites

In order to utalise the workflow with limited changes, each node on the cluster will be running a Debian based OS with SSH access configured, a hostname of `pi<n>` where `<n>` is a letter in the greek alphabet and a `piadmin` user with sudo privaledges.

At time of writing, I am running several Raspberry Pi 4's running Ubuntu 24.04 LTS:
- pialpha
- pibeta
- pigamma
- pidelta

I reserve the right to modify this over time as my cluster grows and changes without necerssarily updating this document (although I will endeavour to keep it up-to-date where possible). Please review particularly the `inventory.yaml` file if you intend to utalise this workflow for your own purposes.

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
7. Generate an SSH keypair, if you have access to another machine running Mac | Linux you can run `ssh-keygen`, this will create two key files in your home directories `.ssh` sub-directory. Otherwise, many password managers (for example Bitwarden) have SSH Key Generators built in. If all else fails you can use an online generator such as [this one](https://www.wpoven.com/tools/create-ssh-key).
8. Copy the private key file (the one without a `.pub` extension), and navigate to `Settings -> Secrets and varaibles -> Actions` in your repo and click `New repository secret`. Call it `SSH_PRIVATE_KEY`.
9. Copy the public key file to each node device, if you have SSH access from the machine where you generated the file, you can do this with `ssh-copy-id <username>@>hostname>`, otherwise on the node itself, open `~/.ssh/authorized_keys` (create it if it doesn't exist) and paste the key on a new line.
10. On each new node, run `echo "piadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/piadmin`, this allows the workflow sudo access without having to store the password in the repo.

For each new node you add to the cluster, run steps 6, 9 and 10. These can be added anytime, not just during initial setup.

## Usage
Navigate to `Actions -> Ansible Deploy` in your repo. If you haven't already, enable GitHub actions for your repo. Now Click `Run workflow`.

The workflow uses a manual `workflow_dispatch` trigger so you can freely make changes to the codebase without triggering the playbook.
