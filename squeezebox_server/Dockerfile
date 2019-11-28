ARG BUILD_FROM=hassioaddons/ubuntu-base:4.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64
ENV SQUEEZE_VOL /share/squeezeboxserver
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PACKAGE_URL=http://downloads-origin.slimdevices.com/nightly/?ver=7.9
ENV PACKAGE_VERSION=7.9.2~1574315728
ENV ARCH=${BUILD_ARCH}

# Install requirements and utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libnginx-mod-http-lua=1.14.0-0ubuntu1.6 \
    luarocks=2.4.2+dfsg-1 \
    nginx=1.14.0-0ubuntu1.6 \
    curl wget nano faad flac lame sox libio-socket-ssl-perl \
    iputils-ping \
    iproute2S

RUN luarocks install lua-resty-http 0.13-0

# Download and install nightly
RUN wget -r --no-directories --no-parent -A 'logitechmediaserver_'${PACKAGE_VERSION}'_'${ARCH}'.deb' ${PACKAGE_URL}
RUN mv logitechmediaserver_${PACKAGE_VERSION}_${ARCH}.deb /tmp/logitechmediaserver.deb
RUN dpkg -i /tmp/logitechmediaserver.deb
RUN rm -f /tmp/logitechmediaserver.deb
RUN rm -fr \
        /tmp/* \
        /etc/nginx \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*
RUN mkdir -p /var/log/nginx
RUN touch /var/log/nginx/error.log
RUN apt-get clean

# This will be created by the entrypoint script.
RUN userdel squeezeboxserver

VOLUME $SQUEEZE_VOL
EXPOSE 3483 3483/udp 9000 9090

COPY entrypoint.sh /entrypoint.sh
COPY start-squeezebox.sh /start-squeezebox.sh

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="squeezeboxserver" \
    io.hass.description="Logitech Squeezebox Server" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="McInnes01 <mcinnes01@hotmail.com>" \
    org.label-schema.description="Logitech Squeezebox Server" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="squeezeboxserver" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/mcinnes01/ihomeaddons/squeezebox_server" \
    org.label-schema.usage="https://github.com/mcinnes01/ihomeaddons/squeezebox_server" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/mcinnes01/ihomeaddons/squeezebox_server" \
    org.label-schema.vendor="Logitech Squeezebox Server Hass.io Add-ons"
    
RUN chmod 755 /entrypoint.sh /start-squeezebox.sh
ENTRYPOINT ["/entrypoint.sh"]