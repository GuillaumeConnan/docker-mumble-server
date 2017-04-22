FROM alpine:edge
MAINTAINER Guillaume CONNAN "guillaume.connan44@gmail.com"
LABEL version="0.2.2"

RUN (                                                                     \
        : "Setting repositories, updating and installing softwares"    && \
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/main"             \
             >  /etc/apk/repositories                                  && \
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/community"        \
             >> /etc/apk/repositories                                  && \
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing"          \
             >> /etc/apk/repositories                                  && \
        apk --no-cache update                                          && \
        apk --no-cache upgrade                                         && \
        apk --no-cache add sudo icu murmur                             && \
                                                                          \
        : "murmur 1.2.19-r1"                                           && \
        mkdir -p /mumble-server /run/mumble-server                     && \
        chown -R murmur:murmur /mumble-server /run/mumble-server       && \
                                                                          \
        : "Cleaning"                                                   && \
        rm -fr /tmp/* /var/cache/apk/* /var/tmp/* /var/run             && \
        ln -s /run /var/run                                               \
    )

ADD scripts/start.sh /start.sh

# Expose port and volume

EXPOSE 64738

VOLUME ["/mumble-server"]

# Init

CMD ["/bin/sh", "/start.sh"]
