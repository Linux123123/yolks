#!/bin/bash
set -e
cd /home/container

# Preserve the existing persistent startup script and CRDB invocation.
if [ ! -f /home/container/start.sh ]; then
    cp /usr/local/share/cockroach/start.sh /home/container/start.sh
fi

if [ -f /home/container/tikv-config/enabled ]; then
    exec python3 /usr/local/share/cockroach/supervise.py
fi
exec /bin/bash /home/container/start.sh
