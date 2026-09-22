#!/bin/bash
set -e

cd /home/container

# Pterodactyl mounts the server directory over /home/container. Seed a default
# startup script on first boot so each server can customize it in its file manager.
if [ ! -f /home/container/start.sh ]; then
    cp /usr/local/share/cockroach/start.sh /home/container/start.sh
fi

exec /bin/bash /home/container/start.sh
