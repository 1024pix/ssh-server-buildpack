#!/usr/bin/env bash

set -euxo pipefail

SSH_PORT=${1:-}
shift
BACKGROUND_COMMAND=("$@")

mkdir -p /app/etc/ssh/
ssh-keygen -A -f /app/
# set key auth in file
if [[ ! -f /app/config/.ssh/authorized_keys ]]; then
  mkdir -p /app/config/.ssh/
  touch /app/config/.ssh/authorized_keys
fi
if [[ -n "$PUBLIC_KEY" ]]; then
  if ! grep -q "${PUBLIC_KEY}" /app/config/.ssh/authorized_keys; then
    echo "$PUBLIC_KEY" >>/app/config/.ssh/authorized_keys

    echo "Public key from env variable added"
  fi
fi
chmod 600 /app/config/.ssh/authorized_keys
chmod -R 700 /app/etc/ssh/

echo "exec background task"

trap "exit" INT TERM ERR
trap "kill 0" EXIT

if [[ -n "$BACKGROUND_COMMAND" ]]; then
  "${BACKGROUND_COMMAND[@]}" &
fi

/app/vendor/openssh/sbin/sshd -f /app/vendor/openssh/etc/sshd_config -D -p "$SSH_PORT" &

wait
