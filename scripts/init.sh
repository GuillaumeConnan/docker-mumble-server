#!/bin/bash

# Create default config if it doesn't exist
if [ ! -f "/mumble/mumble-server.ini" ]; then
    cp /mumble-default/mumble-server.ini /mumble/mumble-server.ini
fi

# Setting serverpassword
if [ -n "$SERVERPASSWORD" ]; then
    sed -i 's/serverpassword=.*/serverpassword='"$SERVERPASSWORD"'/' /mumble/mumble-server.ini
fi

# Setting correct permissions
chown -R mumble-server:mumble-server /mumble

# Setting supw
if [ -n "$SUPW" ]; then
    sudo -u mumble-server /usr/sbin/murmurd -fg -ini /mumble/mumble-server.ini -supw "$SUPW"
fi

# Remove old PID files
if [ -f "/run/supervisord.pid" ]; then
    /bin/rm -f /run/supervisord.pid
fi
if [ -f "/var/run/mumble-server/mumble-server.pid" ]; then
    /bin/rm -f /var/run/mumble-server/mumble-server.pid
fi

# Init
/usr/bin/python /usr/bin/supervisord
