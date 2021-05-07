FROM ubuntu:latest

RUN apt update && \
    apt install -y locales && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata
RUN apt install -y \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python vim sharutils \
      zlib1g-dev libncurses5 wget bsdmainutils curl automake clang && \
    apt clean -y

RUN useradd -m bzedge
USER bzedge
RUN mkdir $HOME/.bzedge
RUN git clone -b dev-440 https://github.com/bze-alphateam/bzedge $HOME/bzedge 
RUN CONFIGURE_FLAGS="--enable-debug --disable-tests --disable-bench" HOST=x86_64-linux-gnu ./$HOME/bzedge/zcutil/build.sh 
RUN ./$HOME/bzedge/zcutil/fetch-params.sh
RUN touch $HOME/.bzedge/bzedge.conf
RUN echo 'addnode=167.86.99.150' >> $HOME/.bzedge/bzedge.conf
EXPOSE 1980:1980 1990:1990

ENTRYPOINT ["./home/bzedge/bzedge/src/bzedged", "--graylist"]
