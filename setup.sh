#!/bin/bash
sudo apt update && sudo apt dist-upgrade -y
sudo apt install openssh-server
sudo service ssh start
nix-env -iA nixpkgs.neovim
pipx install github-cli
