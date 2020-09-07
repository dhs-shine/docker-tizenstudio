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
  ruby \
  tzdata \
  virtualenv \
  python \
  python-requests \
  python-pycurl \
  python-lxml \
  python3-requests \
  python3-lxml \
  python3-yaml \
  python3-jinja2 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/*

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
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/*

# Install dotnet core 3.1 sdk
RUN \
  wget https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb
RUN \
  apt-get update && \
  apt-get install -y dotnet-sdk-3.1 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /etc/apt/sources.list.d/*

# Install mono-devel and nuget
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && sh -c 'echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" > /etc/apt/sources.list.d/mono-official-stable.list' \
  && apt-get update \
  && apt-get install -y nuget mono-devel \
  && rm -rf /var/lib/apt/lists/*

# Add a user
ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group} \
  && useradd -d "$HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER ${user}
WORKDIR ${HOME}

# Install tizen studio 3.7
RUN \
  wget http://download.tizen.org/sdk/Installer/tizen-studio_3.7/web-cli_Tizen_Studio_3.7_ubuntu-64.bin \
  && chmod +x web-cli_Tizen_Studio_3.7_ubuntu-64.bin \
  && echo y | ./web-cli_Tizen_Studio_3.7_ubuntu-64.bin --accept-license \
  && rm -rf web-cli_Tizen_Studio_3.7_ubuntu-64.bin

# Install sdk-build
RUN \
  git clone git://git.tizen.org/sdk/tools/sdk-build -b tizen

# Set PATH
ENV PATH $PATH:$HOME/tizen-studio/tools/ide/bin/:$HOME/tizen-studio/package-manager/:$HOME/sdk-build/