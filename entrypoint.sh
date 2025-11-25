#!/bin/bash
printenv | grep -v "no_proxy" >> /etc/environment

cron && busybox syslogd -n -O-
