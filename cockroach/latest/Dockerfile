# Preserve the exact CockroachDB image currently used by CRDB1-9.
FROM --platform=$TARGETOS/$TARGETARCH ghcr.io/linux123123/linux123123:cockroach_latest@sha256:0fa12036cff06df7441743a0a79263cbf6e6f3d78a915ab483dfb20dc879b1ae

ARG TARGETARCH
USER root
ENV DEBIAN_FRONTEND=noninteractive
COPY ./latest/tikv-checksums.sha256 /tmp/tikv-checksums.sha256
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 \
    && case "${TARGETARCH}" in amd64|arm64) ;; *) exit 1 ;; esac \
    && for component in pd tikv; do \
         archive="${component}-v8.5.6-linux-${TARGETARCH}.tar.gz"; \
         curl -fSL --retry 3 "https://tiup-mirrors.pingcap.com/${archive}" -o "/tmp/${archive}"; \
         (cd /tmp && grep "  ${archive}$" tikv-checksums.sha256 | sha256sum -c -); \
         mkdir -p /tmp/extract; \
         tar -xzf "/tmp/${archive}" -C /tmp/extract; \
         binary="$(find /tmp/extract -type f -name "${component}-server" -print -quit)"; \
         test -n "$binary"; \
         install -m 0755 "$binary" "/usr/local/bin/${component}-server"; \
         rm -rf /tmp/extract "/tmp/${archive}"; \
       done \
    && rm -f /tmp/tikv-checksums.sha256 \
    && rm -rf /var/lib/apt/lists/*
COPY ./latest/supervise.py /usr/local/share/cockroach/supervise.py
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh
USER container
WORKDIR /home/container
STOPSIGNAL SIGINT
CMD ["/bin/bash", "/entrypoint.sh"]
