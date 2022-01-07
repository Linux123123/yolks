FROM        node:16-bullseye-slim

LABEL       author="Linux123123" maintainer="linas.alexx@gmail.com"

LABEL       org.opencontainers.image.source="https://github.com/linux123123/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN         apt-get update && apt-get -y install ffmpeg git python3 build-essential iproute2 ash
RUN			adduser -D -h /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         [ "/bin/ash", "/entrypoint.sh" ]
