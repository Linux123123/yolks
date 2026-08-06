FROM        --platform=$TARGETOS/$TARGETARCH debian:trixie-slim

LABEL       author="Linux123123" maintainer="me@linux123123.com"
LABEL       org.opencontainers.image.source="https://github.com/linux123123/yolks"
LABEL       org.opencontainers.image.licenses=MIT

ENV         DEBIAN_FRONTEND=noninteractive

RUN         apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		iproute2 \
		libgdiplus \
		libicu76 \
		tini \
	&& curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
	&& chmod +x /tmp/dotnet-install.sh \
	&& /tmp/dotnet-install.sh --channel 10.0 --install-dir /usr/share/dotnet \
	&& ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
	&& useradd -d /home/container -m container \
	&& rm -f /tmp/dotnet-install.sh \
	&& rm -rf /var/lib/apt/lists/*

USER        container
ENV         USER=container HOME=/home/container DOTNET_ROOT=/usr/share/dotnet
WORKDIR     /home/container

STOPSIGNAL  SIGINT

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/usr/bin/tini", "-g", "--"]
CMD         ["/bin/bash", "/entrypoint.sh"]
