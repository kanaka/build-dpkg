FROM ubuntu:focal

# Installs the `dpkg-buildpackage` command
RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential debhelper devscripts

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
