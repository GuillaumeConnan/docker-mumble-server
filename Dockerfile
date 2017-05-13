FROM debian:stretch

MAINTAINER Guillaume CONNAN "guillaume.connan44@gmail.com"

LABEL version="0.3.2"              \
      mumble_version="1.2.18-1"

ENV DEBIAN_FRONTEND noninteractive

RUN (                                                                                       \
        echo "deb http://deb.debian.org/debian stretch main contrib non-free"               \
             >  /etc/apt/sources.list                                                    && \
        echo "deb http://deb.debian.org/debian stretch-updates main contrib non-free"       \
             >> /etc/apt/sources.list                                                    && \
        echo "deb http://security.debian.org stretch/updates main contrib non-free"         \
             >> /etc/apt/sources.list                                                    && \
        apt-get update                                                                   && \
        apt-get -y -q upgrade                                                            && \
        apt-get -y -q dist-upgrade                                                       && \
        apt-get -y -q autoclean                                                          && \
        apt-get -y -q autoremove                                                         && \
        apt-get -y -q install sudo                                                          \
                              mumble-server                                              && \
        mkdir -p /mumble-server                                                          && \
        chown -R mumble-server:mumble-server /mumble-server                              && \
        apt-get clean                                                                    && \
        rm -fr /tmp/*                                                                    && \
        rm -fr /var/tmp/*                                                                && \
        rm -fr /var/lib/apt/lists/*                                                         \
    )

ADD scripts/start.sh /start.sh

# Expose port and volume
EXPOSE 64738
VOLUME ["/mumble-server"]

# Init
CMD ["/bin/sh", "/start.sh"]
