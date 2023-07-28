FROM        --platform=$TARGETOS/$TARGETARCH node:18-slim

LABEL       author="Linux123123" maintainer="me@linux123123.com"

LABEL       org.opencontainers.image.source="https://github.com/linux123123/yolks"
LABEL       org.opencontainers.image.licenses=MIT

RUN         apt-get -y update
RUN         apt-get -y install git build-essential iproute2 python3 iptables sudo
RUN			useradd -d /home/container -m container


RUN         chown root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
RUN         echo 'Cmnd_Alias net=/usr/bin/iptables' >> /etc/sudoers
RUN         echo 'ALL ALL=NOPASSWD: net' >> /etc/sudoers

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
