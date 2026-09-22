#!/bin/bash
set -e

cd /home/container
mkdir -p /home/container/cockroach-data
mkdir -p /home/container/certs

# Pterodactyl supplies SERVER_IP and SERVER_PORT as environment variables.
# SERVER_IP must be the address clients use to reach this server.
SERVER_IP="${SERVER_IP:-127.0.0.1}"
SERVER_PORT="${SERVER_PORT:-26257}"
HTTP_PORT="${HTTP_PORT:-8080}"
CERTS_DIR=/home/container/certs

# Generate persistent TLS certificates on first boot. Keep ca.key private.
if [ ! -f "${CERTS_DIR}/ca.crt" ] || [ ! -f "${CERTS_DIR}/ca.key" ]; then
    cockroach cert create-ca --certs-dir="${CERTS_DIR}" --ca-key="${CERTS_DIR}/ca.key"
fi

if [ ! -f "${CERTS_DIR}/node.crt" ] || [ ! -f "${CERTS_DIR}/node.key" ]; then
    cockroach cert create-node localhost 127.0.0.1 "${SERVER_IP}" \
        --certs-dir="${CERTS_DIR}" --ca-key="${CERTS_DIR}/ca.key"
fi

if [ ! -f "${CERTS_DIR}/client.root.crt" ] || [ ! -f "${CERTS_DIR}/client.root.key" ]; then
    cockroach cert create-client root \
        --certs-dir="${CERTS_DIR}" --ca-key="${CERTS_DIR}/ca.key"
fi

chmod 0600 "${CERTS_DIR}/ca.key" "${CERTS_DIR}/node.key" "${CERTS_DIR}/client.root.key"

exec cockroach start-single-node \
    --certs-dir="${CERTS_DIR}" \
    --listen-addr="0.0.0.0:${SERVER_PORT}" \
    --advertise-addr="${SERVER_IP}:${SERVER_PORT}" \
    --http-addr="0.0.0.0:${HTTP_PORT}" \
    --store=/home/container/cockroach-data
