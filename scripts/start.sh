#!/bin/sh

mkdir -p ${MS_PIDPATH:=/var/run/mumble-server/}
${MS_PIDFILE:=$MS_PIDPATH/mumble-server.pid}

${MS_CONFIGFILE:=/mumble-server/mumble-server.ini}
${MS_DATABASE:=/mumble-server/mumble-server.sqlite}

# Generate config if needed
if [ ! -f "$MS_CONFIGFILE" ]
then
    echo "database=$MS_DATABASE"                                                                              >  $MS_CONFIGFILE
    echo "icesecretwrite="                                                                                    >> $MS_CONFIGFILE
    echo "logfile="                                                                                           >> $MS_CONFIGFILE
    echo "pidfile=$MS_PIDFILE"                                                                                >> $MS_CONFIGFILE
    echo "welcometext=\"<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />\""    >> $MS_CONFIGFILE
    echo "port=64738"                                                                                         >> $MS_CONFIGFILE
    echo "serverpassword=$MS_SERVERPASSWORD"                                                                  >> $MS_CONFIGFILE
    echo "bandwidth=${MS_BANDWIDTH:=130000}"                                                                  >> $MS_CONFIGFILE
    echo "users=${MS_USERS:=100}"                                                                             >> $MS_CONFIGFILE
    echo "uname=mumble-server"                                                                                >> $MS_CONFIGFILE
    echo "[Ice]"                                                                                              >> $MS_CONFIGFILE
    echo "Ice.Warn.UnknownProperties=1"                                                                       >> $MS_CONFIGFILE
    echo "Ice.MessageSizeMax=65536"                                                                           >> $MS_CONFIGFILE
else
    # If config file exists, only set serverpassword if defined
    if [ -n "$MS_SERVERPASSWORD" ]
    then
        sed -i "s/serverpassword=.*/serverpassword=$MS_SERVERPASSWORD/" $MS_CONFIGFILE
    fi
fi

# Remove old PID file
if [ -f "$MS_PIDFILE" ]
then
    rm -f $MS_PIDFILE
fi

# Setting supw
if [ -n "$MS_SUPW" ]
then
    /usr/sbin/murmurd -fg -ini $MS_CONFIGFILE -supw "$MS_SUPW"
else
	if [ ! -f "$MS_DATABASE" ]
	then
		MS_SUPW=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
		/usr/sbin/murmurd -fg -ini $MS_CONFIGFILE -supw "$MS_SUPW"
		echo $MS_SUPW > /mumble-server/supw
	fi
fi

chown -R mumble-server:mumble-server /mumble-server $MS_PIDPATH

# Init
sudo -u mumble-server /usr/sbin/murmurd -fg -ini $MS_CONFIGFILE
