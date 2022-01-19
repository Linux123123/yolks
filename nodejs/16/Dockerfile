FROM        node:16-bullseye-slim

LABEL       author="Linux123123" maintainer="linas.alexx@gmail.com"

LABEL       org.opencontainers.image.source="https://github.com/linux123123/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN         apt-get -y update
RUN         apt-get -y install curl jo ca-certificates openssl ffmpeg git tar python3 build-essential iproute2 sqlite3
RUN			useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
