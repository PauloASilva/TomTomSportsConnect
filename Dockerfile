# Base image
FROM bitnami/minideb:stretch

LABEL author="Paulo A. Silva"
LABEL url="https://github.com/PauloASilva/TomTomSportsConnect"
LABEL description="Containerized TomTom Sports Connect"

ENV PACKAGE="tomtomsportsconnect.x86_64.deb"
ENV URL="https://sports.tomtom-static.com/downloads/desktop/mysportsconnect/latest/$PACKAGE"

WORKDIR "/tmp"

# Handle dependencies
RUN install_packages \
    network-manager \
    libgl1-mesa-glx \
    "libxslt1.1" \
    "libsm6" \
    liborc-0.4-0 \
    iso-codes \
    libxrender1 \
    libxcomposite-dev \
    wget

RUN wget --quiet http://fr.archive.ubuntu.com/ubuntu/pool/main/g/gst-plugins-base0.10/libgstreamer-plugins-base0.10-0_0.10.36-1_amd64.deb
RUN wget --quiet http://fr.archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10/libgstreamer0.10-0_0.10.36-1.5ubuntu1_amd64.deb

RUN dpkg -i libgstreamer*.deb

# Install TomTom Sports Connect
RUN wget --quiet --no-check-certificate $URL
RUN dpkg -i $PACKAGE; exit 0

# postinstall workaround: disable udevadm
ENV POSTINST=/var/lib/dpkg/info/tomtomsportsconnect.postinst

RUN cp $POSTINST "$POSTINST.bak" && \
    head -n-2 "$POSTINST.bak" > "$POSTINST" && \
    rm "$POSTINST.bak" && \
    apt-get -f install
#

# inherit timezone from host system
# docker build needs to be executed with "--build-arg LOCALTIMEZONE=Region/City"
# e.g. "--build-arg LOCALTIMEZONE=Europe/Berlin" 
# if docker build is invoked with bundled script "build_dockerimage.sh", LOCALTIMEZONE will
# be get from host system
ARG LOCALTIMEZONE
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -f tzdata
RUN ln -fs /usr/share/zoneinfo/$LOCALTIMEZONE /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata


# Cleanup
RUN apt-get remove -y --purge wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -r /tmp/*

ENV PATH="$PATH:/usr/local/TomTomSportsConnect/bin/"

CMD ["TomTomSportsConnect"]

