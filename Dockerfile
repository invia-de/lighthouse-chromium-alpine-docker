FROM alpine:latest

LABEL description "Run Google Chrome's Lighthouse Audit in the background"

LABEL version="2.0.0"

LABEL author="Matthias Winkelmann <m@matthi.coffee> | Marco Neumann <marco.neumann@invia.de>"

LABEL de.invia.vcs="https://github.com/invia-de/lighthouse-chromium-alpine-docker"
LABEL de.invia.uri="https://www.invia.de"

LABEL coffee.matthi.vcs-url="https://github.com/MatthiasWinkelmann/lighthouse-chromium-alpine-docker"
LABEL coffee.matthi.uri="https://matthi.coffee"
LABEL coffee.matthi.usage="/README.md"

WORKDIR /
USER root

#-----------------
# Set ENV
#-----------------
ENV OUTPUT_PATH /home/lighthouse/output

ENV TZ "Europe/Berlin"
RUN echo $TZ > /etc/timezone

#-----------------
# Add packages
#-----------------

RUN apk -U --no-cache update
RUN apk -U --no-cache add \
    zlib-dev \
    chromium \
    xvfb \
    wait4ports \
    xorg-server \
    dbus \
    ttf-freefont \
    mesa-dri-swrast \
    py2-pip \
    npm

# Install lighthouse
RUN npm --global install yarn && yarn global add lighthouse

# Delete Caches
RUN rm -rf /var/lib/apt/lists/* \
    /var/cache/apk/* \
    /usr/share/man \
    /tmp/* \
    /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html \
    /usr/lib/node_modules/npm/scripts

# Add Lighthouse as a user
RUN addgroup lighthouse && adduser -S -g lighthouse lighthouse \
    && mkdir -p /home/lighthouse && mkdir /home/lighthouse/output && chown -R lighthouse:lighthouse /home/lighthouse \
		&& mkdir -p /opt/google/lighthouse && chown -R lighthouse:lighthouse /opt/google/lighthouse

# Install Python Requirements (needed for github Gists)
RUN pip2 install --no-cache-dir gists.cli

# Add Output Volume
VOLUME /home/lighthouse/output

# Run Chrome non-privileged
USER lighthouse

# Set workdir
WORKDIR /home/lighthouse

# Copy needed files
COPY lighthouse-chromium.sh ./
COPY .git-credentials ./

ENTRYPOINT ["./lighthouse-chromium.sh"]
