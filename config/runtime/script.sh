#!/bin/bash

# Fix the remote syslog host
sudo printf '\nhostname: '$BOX_HOSTNAME >> /etc/remote-syslog/log_files.yml

# Start supervisor
service supervisor stop
supervisord -n
