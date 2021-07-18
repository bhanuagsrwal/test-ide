# ============================================================
# First stage: Builder image
# Start with Ubuntu Bionic Beaver
# ============================================================

FROM ubuntu:18.04 AS builder

# ------------------------------------------------------------
# Install the curl, xz-utils, wget, git, sudo and build-essential packages
# ------------------------------------------------------------
# https://packages.ubuntu.com/bionic/curl
# https://packages.ubuntu.com/bionic/xz-utils
# https://packages.ubuntu.com/bionic/wget
# https://packages.ubuntu.com/bionic/git
# https://packages.ubuntu.com/bionic/sudo
# https://packages.ubuntu.com/bionic/build-essential

RUN apt-get update && apt-get -y install curl xz-utils wget git sudo build-essential
RUN apt-get -y install libx11-dev libxkbfile-dev

# ------------------------------------------------------------
# Install Node v10
# ------------------------------------------------------------

RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# ------------------------------------------------------------
# Install Yarn
# ------------------------------------------------------------

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

RUN sudo apt update && sudo apt install yarn

# ------------------------------------------------------------
# Install Python language support
# ------------------------------------------------------------

RUN apt-get update && apt-get install -y python python-pip
RUN pip install python-language-server

# ------------------------------------------------------------
# Install Ruby language support
# ------------------------------------------------------------

RUN apt-get -y install ruby ruby-dev zlib1g-dev
RUN gem install solargraph

# ------------------------------------------------------------
# Build the app
# ------------------------------------------------------------

RUN mkdir -p /home/theia

WORKDIR /home/theia

ADD package.json ./package.json

RUN sudo yarn --cache-folder ./ycache && sudo rm -rf ./ycache
RUN NODE_OPTIONS="--max_old_space_size=32768000" sudo yarn theia build

# ============================================================
# Second stage: Working image
# Ubuntu Bionic Beaver
# ============================================================

RUN mkdir -p /home/theia && mkdir -p /home/project

WORKDIR /home/theia

COPY --from=builder /home/theia .

ADD package.json ./package.json

# ------------------------------------------------------------
# Expose the port that the app will run on
# ------------------------------------------------------------

EXPOSE $PORT
