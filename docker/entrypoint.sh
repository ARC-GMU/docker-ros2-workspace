#!/usr/bin/env bash
set -e

if [ "$1" = "sshd" ] || [ "$#" -eq 0 ]; then
    ssh-keygen -A
    exec /usr/sbin/sshd -D -e
fi

exec "$@"
