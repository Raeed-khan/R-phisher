FROM alpine:latest

# Metadata and Repository Info
LABEL MAINTAINER="https://github.com/Raeed-khan/R-phisher"

# Setting up Working Directory inside container
WORKDIR /r-phisher/

# Copying repository files into the container
ADD . /r-phisher

# Installing core dependencies via apk package manager
RUN apk add --no-cache bash ncurses curl unzip wget php && \
    chmod +x /r-phisher/R-phisher.sh

# Default command to run when container starts
CMD ["bash", "./R-phisher.sh"]
