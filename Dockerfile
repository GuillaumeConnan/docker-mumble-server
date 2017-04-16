#
# VERSION 0.1.0
#

FROM debian:stretch
MAINTAINER Guillaume CONNAN "guillaume.connan44@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Setting repositories, updating and installing softwares

RUN echo "deb http://deb.debian.org/debian stretch main contrib non-free"         >  /etc/apt/sources.list    && \
    echo "deb http://deb.debian.org/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list    && \
    echo "deb http://security.debian.org stretch/updates main contrib non-free"   >> /etc/apt/sources.list

RUN apt-get update                && \
    apt-get -y -q upgrade         && \
    apt-get -y -q dist-upgrade    && \
    apt-get -y -q autoclean       && \
    apt-get -y -q autoremove

RUN apt-get -y -q install sudo             \
                          supervisor       \
                          mumble-server

# Mumble-server

RUN mkdir -p /opt/mumble-server         \
             /opt/mumble-server-back

ADD conf/mumble-server/mumble-server.ini /opt/mumble-server-back/mumble-server.ini

RUN chown -R mumble-server:mumble-server /opt/mumble-server         && \
    chown -R mumble-server:mumble-server /opt/mumble-server-back

# Cleaning

RUN apt-get clean                  && \
    rm -fr /tmp/*                  && \
    rm -fr /var/tmp/*              && \
    rm -fr /var/lib/apt/lists/*

# Adding services

RUN mkdir -p /var/log/supervisor

ADD conf/supervisor/supervisor.conf /etc/supervisor/conf.d/supervisor.conf
ADD scripts/init.sh                 /init.sh

# Expose ports and volumes

EXPOSE 64738

VOLUME ["/var/log/supervisor/", "/opt/mumble-server/"]

# Init

CMD ["/bin/bash", "-e", "/init.sh"]