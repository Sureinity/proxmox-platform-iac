#!/usr/bin/env bash
set -euo pipefail

sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

sudo cloud-init clean --logs --seed
sudo rm -f /etc/ssh/ssh_host_*

sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -sf /etc/machine-id /var/lib/dbus/machine-id

sudo find /var/log -type f -exec truncate -s 0 {} \;
sudo sync
