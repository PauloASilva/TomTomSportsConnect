# Base image
# See https://github.com/phusion/baseimage-docker
FROM phusion/baseimage

LABEL author="Paulo A. Silva"
LABEL url="https://github.com/PauloASilva/TomTomSportsConnect"
LABEL description="Containerized TomTom Sports Connect"

RUN apt-get update && apt-get install wget

ENV PACKAGE="tomtomsportsconnect.x86_64.deb"
ENV URL="https://sports.tomtom-static.com/downloads/desktop/mysportsconnect/latest/$PACKAGE"

# Handle dependencies
RUN apt-get install -y \
    network-manager \
    libgstreamer0.10-0 \
    libgstreamer-plugins-base0.10-0 \
    libgl1-mesa-glx \
    "libxslt1.1" \
    "libsm6"

RUN curl -Lk -o /tmp/$PACKAGE $URL

RUN dpkg -i /tmp/$PACKAGE; exit 0

# Fix postinstall
## Disable udevadm
ENV POSTINST=/var/lib/dpkg/info/tomtomsportsconnect.postinst

RUN cp $POSTINST "$POSTINST.bak" && \
    head -n-2 "$POSTINST.bak" > "$POSTINST"

RUN apt-get -f install

ENV PATH="$PATH:/usr/local/TomTomSportsConnect/bin/"

CMD ["TomTomSportsConnect"]

