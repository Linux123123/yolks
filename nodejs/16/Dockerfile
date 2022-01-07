FROM        node:16-bullseye-slim

LABEL       author="Linux123123" maintainer="linas.alexx@gmail.com"

LABEL       org.opencontainers.image.source="https://github.com/linux123123/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN         apt-get -y install curl python3 ffmpeg git sqlite tar tzdata \
				&& adduser -D -h /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         [ "/bin/ash", "/entrypoint.sh" ]
