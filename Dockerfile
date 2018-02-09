FROM ubuntu:16.04

ARG user=developer
ARG group=developer
ARG uid=2000
ARG gid=2000

# Install prerequisites
RUN \
  apt-get update \
  && apt-get install -y \
  ca-certificates \
  wget \
  curl \
  zip \
  software-properties-common \
  apt-transport-https \
  pciutils \
  libxcb-xfixes0 \
  libxi6 \
  libpixman-1-0 \
  libxcb-render-util0 \
  python2.7 \
  libwebkitgtk-1.0-0 \
  libxcb-image0 \
  acl \
  libsdl1.2debian \
  libv4l-0 \
  libxcb-randr0 \
  libxcb-shape0 \
  libx11-xcb1 \
  libxcb-icccm4 \
  libfontconfig1 \
  libsm6 \
  libjpeg-turbo8 \
  gettext \
  rpm2cpio \
  cpio \
  make \
  bridge-utils \
  openvpn \
  git \
  && rm -rf /var/lib/apt/lists/*

# Install Java
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && add-apt-repository -y ppa:webupd8team/java \
  && apt-get update \
  && apt-get install -y oracle-java8-installer \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/oracle-jdk8-installer

# Install dotnet core prerequisites
RUN \
  apt-get update \
  && apt-get install -y \
  libunwind8 \
  liblttng-ust0 \
  libcurl3 \
  libssl1.0.0 \
  libuuid1 \
  libkrb5-3 \
  zlib1g \
  libicu55 \
  && rm -rf /var/lib/apt/lists/*

# Install dotnet core 2.0 sdk
RUN \
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN \
  sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list' \
  && apt-get update \
  && apt-get install -y dotnet-sdk-2.0.0 \
  && rm -rf /var/lib/apt/lists/*

# Add a user
ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group} \
  && useradd -d "$HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER ${user}
WORKDIR ${HOME}

# Install tizen studio 2.1
RUN \
  wget http://download.tizen.org/sdk/Installer/tizen-studio_2.1/web-cli_Tizen_Studio_2.1_ubuntu-64.bin \
  && chmod +x web-cli_Tizen_Studio_2.1_ubuntu-64.bin \
  && echo y | ./web-cli_Tizen_Studio_2.1_ubuntu-64.bin --accept-license \
  && rm -rf web-cli_Tizen_Studio_2.1_ubuntu-64.bin

# Set PATH
ENV PATH $PATH:$HOME/tizen-studio/tools/ide/bin/:$HOME/tizen-studio/package-manager/
