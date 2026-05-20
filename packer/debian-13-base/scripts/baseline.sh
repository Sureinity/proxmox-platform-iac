#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -y
sudo apt-get dist-upgrade -y
sudo apt-get install -y \
  ca-certificates \
  cloud-init \
  curl \
  python3 \
  qemu-guest-agent \
  sudo

sudo systemctl enable qemu-guest-agent
sudo systemctl enable ssh
