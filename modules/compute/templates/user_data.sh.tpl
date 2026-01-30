#!/bin/bash
set -euxo pipefail

# Log user-data execution for troubleshooting
touch /var/log/user-data.log
chmod 600 /var/log/user-data.log
exec > >(tee -a /var/log/user-data.log | logger -t user-data -s 2>/dev/console)
exec 2>&1

export DEBIAN_FRONTEND=noninteractive

retry() {
  local attempts=$1
  shift
  local count=0
  until "$@"; do
    count=$((count + 1))
    if [ "$count" -ge "$attempts" ]; then
      echo "command failed after $${attempts} attempts: $*"
      return 1
    fi
    sleep $((count * 3))
  done
}

retry 5 apt-get update -y
%{ if perform_system_upgrade }
retry 3 apt-get upgrade -y
%{ endif }
retry 3 apt-get install -y unzip openjdk-11-jdk docker.io curl

curl -fsSL "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -aG docker ubuntu || true
systemctl enable docker
systemctl start docker

configure_swap() {
  local swap_gib=$1
  if [ -z "$swap_gib" ] || [ "$swap_gib" -eq 0 ]; then
    echo "Swap size not requested; skipping"
    return 0
  fi

  if swapon --show | grep -q '/swapfile'; then
    echo "Swapfile already present; skipping creation"
    return 0
  fi

  local swap_path="/swapfile"
  local swap_size="$${swap_gib}G"

  echo "Creating swapfile at $${swap_path} with size $${swap_size}"
  if ! fallocate -l "$swap_size" "$swap_path"; then
    echo "fallocate failed; falling back to dd"
    dd if=/dev/zero of="$swap_path" bs=1G count=$${swap_gib}
  fi

  chmod 600 "$swap_path"
  mkswap "$swap_path"
  swapon "$swap_path"

  if ! grep -q '^/swapfile' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
  fi
}

configure_swap ${swap_size_gib}
