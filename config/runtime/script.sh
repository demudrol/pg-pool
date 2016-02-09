#!/bin/bash

# Fix the remote syslog host
sudo printf '\nhostname: '$BOX_HOSTNAME >> /etc/remote-syslog/log_files.yml

# Update kernel memory so pgpool does not fail
sudo sysctl -w kernel.shmmax=134217728
sudo printf '\nkernel.shmmax = 134217728' >> /etc/sysctl.conf

# Run the pgpool upstream configure
cd /tmp && ./pgpool_configure.sh

# Start supervisor
service supervisor stop
supervisord -n
