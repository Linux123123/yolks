FROM        --platform=$TARGETOS/$TARGETARCH openjdk:8-jdk

LABEL       author="linux123123" maintainer="me@linux123123.com"

RUN apt-get update -y \
 && apt-get install fontconfig iproute2 curl ca-certificates unzip tar jq -y \
 && useradd -d /home/container -m container

USER container
ENV  USER=container HOME=/home/container LANG=C.UTF-8

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]
