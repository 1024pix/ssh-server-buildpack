#!/usr/bin/env bash
SSH_PORT=${1:-}
# set key auth in file
if [[ ! -f /app/config/.ssh/authorized_keys ]]; then
  touch /app/config/.ssh/authorized_keys
fi

if [[ -n "$PUBLIC_KEY" ]]; then
  if ! grep -q "${PUBLIC_KEY}" /app/config/.ssh/authorized_keys; then
    echo "$PUBLIC_KEY" >>/app/config/.ssh/authorized_keys
    echo "Public key from env variable added"
  fi
fi

sshd -f /app/vendor/openssh/etc/sshd_config -D -p "$SSH_PORT"
