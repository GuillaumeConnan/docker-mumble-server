#!/bin/sh

${MS_CONFIGFILE:=/mumble-server/mumble-server.ini}
${MS_PIDFILE:=/var/run/mumble-server/mumble-server.pid}

# Generating config if needed
if [ ! -f "$MS_CONFIGFILE" ]; then
    echo "database=${MS_DATABASE:=/mumble-server/mumble-server.sqlite}"                                       >  $MS_CONFIGFILE
    echo "icesecretwrite="                                                                                    >> $MS_CONFIGFILE
    echo "logfile="                                                                                           >> $MS_CONFIGFILE
    echo "pidfile=$MS_PIDFILE"                                                                                >> $MS_CONFIGFILE
    echo "welcometext=\"<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />\""    >> $MS_CONFIGFILE
    echo "port=64738"                                                                                         >> $MS_CONFIGFILE
    echo "serverpassword=$MS_SERVERPASSWORD"                                                                  >> $MS_CONFIGFILE
    echo "bandwidth=${MS_BANDWIDTH:=130000}"                                                                  >> $MS_CONFIGFILE
    echo "users=${MS_USERS:=100}"                                                                             >> $MS_CONFIGFILE
    echo "uname=murmur"                                                                                       >> $MS_CONFIGFILE
    echo "[Ice]"                                                                                              >> $MS_CONFIGFILE
    echo "Ice.Warn.UnknownProperties=1"                                                                       >> $MS_CONFIGFILE
    echo "Ice.MessageSizeMax=65536"                                                                           >> $MS_CONFIGFILE
fi

# Remove old PID file
if [ -f "$MS_PIDFILE" ]; then
    rm -f $MS_PIDFILE
fi

# Setting supw
if [ -n "$MS_SUPW" ]; then
    /usr/bin/murmurd -fg -ini $MS_CONFIGFILE -supw "$MS_SUPW"
fi

chown -R murmur:murmur /mumble-server

# Init
sudo -u murmur /usr/bin/murmurd -fg -ini $MS_CONFIGFILE
