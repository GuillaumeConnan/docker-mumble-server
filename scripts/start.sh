#!/bin/bash

mkdir -p ${MS_PIDPATH:=/var/run/mumble-server}
MS_PIDFILE=${MS_PIDFILE:="$MS_PIDPATH/mumble-server.pid"}

MS_VOLUME=${MS_VOLUME:="/mumble-server"}

MS_CONFIGFILE=${MS_CONFIGFILE:="$MS_VOLUME/mumble-server.ini"}
MS_LOGFILE=${MS_LOGFILE:="$MS_VOLUME/mumble-server.log"}
MS_DATABASE=${MS_DATABASE:="$MS_VOLUME/mumble-server.sqlite"}

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

if [ ! -f "$MS_LOGFILE" ]
then
	touch $MS_LOGFILE
fi

# Remove old PID file
if [ -f "$MS_PIDFILE" ]
then
    rm -f $MS_PIDFILE
fi

chown -R mumble-server:mumble-server $MS_VOLUME $MS_PIDPATH

# Setting supw
if [ -n "$MS_SUPW" ]
then
    sudo -u mumble-server /usr/sbin/murmurd -fg -ini $MS_CONFIGFILE -supw "$MS_SUPW" &>>$MS_LOGFILE
fi

# Init
sudo -u mumble-server /usr/sbin/murmurd -fg -ini $MS_CONFIGFILE &>>$MS_LOGFILE
