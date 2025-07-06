# PiCluster
GitOps approach to managing the infrastructure for my Raspberry Pi K3S cluster using a traditional `push` (CI/CD) model.
- Built with:
  - Ansible: for automation.
  - Tailscale: for managing network access.
  - GitHub Actions: for CI/CD.

Workflows are idempotent so can be rerun on existing hardware without risk of breakage.

## Pre-requisites

In order to utalise the workflow with limited changes, each node on the cluster will be running a Debian based OS and a user with sudo privaledges.

At time of writing, I am running several Raspberry Pi 4's running Ubuntu 24.04 LTS:
- pialpha
- pibeta
- pigamma

I reserve the right to modify this over time as my cluster grows and changes without necerssarily updating this document (although I will endeavour to keep it up-to-date where possible). Please review particularly the `inventory/hosts.yaml` file if you intend to utalise this workflow for your own purposes.

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
7. On each new node, run `echo "piadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/piadmin`, this allows the workflow sudo access without having to store the password in the repo.

For each new node you add to the cluster, run steps 6 and 7. These can be added anytime, not just during initial setup.

## Usage
Navigate to `Actions -> Ansible Deploy` in your repo. If you haven't already, enable GitHub actions for your repo. Now Click `Run workflow`.
