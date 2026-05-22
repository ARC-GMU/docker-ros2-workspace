#!/bin/bash
set -e

# FIXME: Providing abitrary uid and gid cause sshd to fail to start
if [ "$1" = "sshd" ] || [ "$#" -eq 0 ]; then
    ssh-keygen -A
    if [ "$(id -u)" -eq 0 ]; then
        exec /usr/sbin/sshd -D -e
    fi

    if command -v sudo >/dev/null 2>&1; then
        exec sudo /usr/sbin/sshd -D -e
    fi

    echo "Error: sshd requires root privileges (or sudo), but neither is available for uid $(id -u)." >&2
    exit 1
fi

exec "$@"
