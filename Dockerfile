# Base Application Server
# Contains:
# PHP5.6, Composer, Openresty, New Relic

# Base Ubuntu Image
FROM alpine:3.2

# Maintainer
MAINTAINER moltin

# Update Alpine
RUN apk update

# Add new Relic agent to sources
#RUN wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add -
#RUN echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list

# Create some folders
RUN mkdir /tmp/downloads
RUN mkdir /root/.ssh/

# Install all the things
RUN apk add -f \
	git \
	supervisor \
	nano \
	curl \
	gcc \
	libpcre32 \
	libssl1.0 \
	make \
	perl \
	unzip \
	musl \
    libc6-compat \
	g++ \
	postgresql-dev \
	postgresql-contrib \
	postgresql \
	postgresql-client \
	libpq \
	openssh

# Install PG Pool
RUN mkdir /tmp/downloads/pgpool
RUN curl -J -L http://www.pgpool.net/download.php?f=pgpool-II-3.4.3.tar.gz > /tmp/downloads/pgpool.tar.gz
RUN tar -zxvf /tmp/downloads/pgpool.tar.gz -C /tmp/downloads/pgpool
RUN cd /tmp/downloads/pgpool/pgpool-II-3.4.3 && ./configure && make && make install
