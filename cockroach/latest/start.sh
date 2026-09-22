#!/bin/bash
set -e

cd /home/container
mkdir -p /home/container/cockroach-data

# Pterodactyl supplies SERVER_IP and SERVER_PORT as environment variables.
# SERVER_IP must match an address in node.crt and be reachable by clients.
SERVER_IP="${SERVER_IP:?Set SERVER_IP to an address covered by node.crt}"
SERVER_PORT="${SERVER_PORT:-26257}"
HTTP_PORT="${HTTP_PORT:-8080}"
CERTS_DIR=/home/container/certs

for cert_file in ca.crt node.crt node.key; do
    if [ ! -f "${CERTS_DIR}/${cert_file}" ]; then
        echo "Missing TLS file: ${CERTS_DIR}/${cert_file}" >&2
        exit 1
    fi
done

exec cockroach start-single-node \
    --certs-dir="${CERTS_DIR}" \
    --listen-addr="0.0.0.0:${SERVER_PORT}" \
    --advertise-addr="${SERVER_IP}:${SERVER_PORT}" \
    --http-addr="0.0.0.0:${HTTP_PORT}" \
    --store=/home/container/cockroach-data
