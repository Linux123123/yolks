FROM --platform=$TARGETOS/$TARGETARCH debian:trixie-slim

LABEL author="Linux123123" maintainer="me@linux123123.com"
LABEL org.opencontainers.image.source="https://github.com/linux123123/yolks"
LABEL org.opencontainers.image.licenses=MIT

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl tar \
    && case "${TARGETARCH}" in \
         amd64) cockroach_arch=amd64 ;; \
         arm64) cockroach_arch=arm64 ;; \
         *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
       esac \
    && curl -fsSL "https://binaries.cockroachdb.com/cockroach-latest.linux-${cockroach_arch}.tgz" -o /tmp/cockroach.tgz \
    && tar -xzf /tmp/cockroach.tgz -C /tmp \
    && cockroach_dir="$(find /tmp -maxdepth 1 -type d -name "cockroach-v*.linux-${cockroach_arch}" -print -quit)" \
    && test -n "${cockroach_dir}" \
    && install -d /usr/local/lib/cockroach \
    && install -m 0755 "${cockroach_dir}/cockroach" /usr/local/bin/cockroach \
    && cp -a "${cockroach_dir}"/lib/libgeos*.so* /usr/local/lib/cockroach/ \
    && rm -rf /tmp/cockroach.tgz "${cockroach_dir}" /var/lib/apt/lists/* \
    && useradd --create-home --home-dir /home/container --shell /bin/bash container \
    && mkdir -p /home/container \
    && chown container:container /home/container

COPY ./latest/start.sh /usr/local/share/cockroach/start.sh
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh /usr/local/share/cockroach/start.sh

USER container
ENV USER=container HOME=/home/container
ENV LD_LIBRARY_PATH=/usr/local/lib/cockroach
WORKDIR /home/container

STOPSIGNAL SIGINT
CMD ["/bin/bash", "/entrypoint.sh"]
