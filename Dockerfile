# Base Application Server
# Contains:
# PHP5.6, Composer, Openresty, New Relic

# Base Ubuntu Image
FROM ubuntu:14.04

# Maintainer
MAINTAINER moltin

# Update Alpine
RUN apt-get update

# Add new Relic agent to sources
#RUN wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add -
#RUN echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list

# Create some folders
RUN mkdir /tmp/downloads
RUN mkdir /root/.ssh

# Install all the things
# Install all the things
RUN apt-get install -f -y \
    git \
    supervisor \
    nano \
    curl \
    openssh-server \
    gcc \
    libpcre3 \
    libpcre3-dev \
    libssl-dev \
    make \
    postgresql-contrib \
    libreadline-dev \
    libncurses5-dev \
    perl \
    build-essential \
    gcc \
    unzip \
	libpq-dev \
    --force-yes

# Create PG Pool directories
RUN mkdir -p /var/log/pgpool
RUN mkdir -p /etc/pgpool
RUN mkdir -p /tmp/downloads/pgpool
RUN mkdir /var/run/pgpool

# Install PG Pool
RUN curl -J -L http://www.pgpool.net/download.php?f=pgpool-II-3.4.3.tar.gz > /tmp/downloads/pgpool.tar.gz
RUN tar -zxvf /tmp/downloads/pgpool.tar.gz -C /tmp/downloads/pgpool
RUN cd /tmp/downloads/pgpool/pgpool-II-3.4.3 && ./configure && make && make install

# Add in PG Pool config and password hba
ADD ./config/pgpool/pgpool.conf /etc/pgpool/pgpool.conf
ADD ./config/pgpool/pool_hba.conf /etc/pgpool/pool_hba.conf
ADD ./config/pgpool/pool_passwd /etc/pgpool/pool_passwd

# Add in the remote syslog for papertrailapp
ADD ./config/remote-syslog/log_files.yml /etc/remote-syslog/log_files.yml
RUN cd /tmp && wget https://github.com/papertrail/remote_syslog2/releases/download/v0.13/remote_syslog_linux_amd64.tar.gz && \
    tar xzf ./remote_syslog*.tar.gz && sudo cp ./remote_syslog/remote_syslog /usr/local/bin && \
    chmod +x /usr/local/bin/remote_syslog && \
    mkdir /var/log/remote-syslog

# Add in the various supervisor pieces
ADD ./config/supervisor/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# Add in runtime script
ADD ./config/runtime/script.sh /tmp/script.sh
RUN chmod +x /tmp/script.sh

# Run the box
ENTRYPOINT ["/tmp/script.sh"]
