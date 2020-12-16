#!/bin/sh

# OpenSSHを起動する。
echo "$SSH_PASSWD" | chpasswd
/usr/sbin/sshd &

# Jettyを起動する。
$JAVA_HOME/bin/java -jar $JETTY_HOME/start.jar $JETTY_JAVA_ARGS

