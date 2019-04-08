# This dockerfile allows to run an crawl inside a docker container

# Pull base image.
FROM debian:stable-slim

# Install required packages.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install sudo build-essential autoconf git zip unzip xz-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install libtool libevent-dev libssl-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install python python-dev python-setuptools python-pip
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install net-tools ethtool tshark libpcap-dev
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install xvfb firefox-esr
RUN DEBIAN_FRONTEND=noninteractive apt-get --assume-yes --yes install wget
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Install python requirements.
RUN pip install --upgrade pip
RUN pip install requests

# add host user to container
RUN adduser --system --group --disabled-password --gecos '' --shell /bin/bash docker

# download geckodriver
RUN cd /bin/ && wget https://github.com/mozilla/geckodriver/releases/download/v0.17.0/geckodriver-v0.17.0-linux64.tar.gz
RUN tar -zxvf /bin/geckodriver* -C /bin/
ENV PATH /bin/geckodriver:$PATH

# add setup.py
ADD setup.py /home/docker/tbb_setup/
RUN echo 94.130.28.200 archive.torproject.org >> /etc/hosts && python /home/docker/tbb_setup/setup.py 6.0.6

# Set the display
ENV DISPLAY $DISPLAY
