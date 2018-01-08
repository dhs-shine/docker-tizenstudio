FROM ubuntu:16.04

# Add a user developer
RUN export uid=1000 gid=1000 && \
  mkdir -p /home/developer && \
  mkdir -p /etc/sudoers.d && \
  echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
  echo "developer:x:${gid}:" >> /etc/group && \
  echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
  chmod 0440 /etc/sudoers.d/developer && \
  chown ${uid}:${gid} -R /home/developer

# Install prerequisites
RUN apt-get update && \
  apt-get install -y ca-certificates \
  wget \
  curl \
  zip \
  software-properties-common \
  apt-transport-https \
  pciutils \
  && rm -rf /var/cache/apt/

# Install Java
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Change user and working directory
USER developer
ENV HOME /home/developer
WORKDIR /home/developer

# Add .bashrc to avoid error mesage from tizen cli
RUN touch $HOME/.bashrc

# Install tizen studio 2.1
RUN wget http://download.tizen.org/sdk/Installer/tizen-studio_2.1/web-cli_Tizen_Studio_2.1_ubuntu-64.bin && \
  chmod +x web-cli_Tizen_Studio_2.1_ubuntu-64.bin && \
  echo y | ./web-cli_Tizen_Studio_2.1_ubuntu-64.bin --accept-license && \
  rm -rf web-cli_Tizen_Studio_2.1_ubuntu-64.bin

ENV PATH $PATH:$HOME/tizen-studio/tools/ide/bin/:$HOME/tizen-studio/package-manager/

# Install packages to install tizen api
USER root
RUN apt-get update && \
  apt-get install -y \
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
  && rm -rf /var/cache/apt/
USER developer

CMD /bin/bash
