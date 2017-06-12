# Android Dockerfile
FROM ubuntu:14.04

MAINTAINER Vitali Adamenka <zdradnik@gmail.com>

ARG USER_NAME="root"
ARG USER_EMAIL="root@mail.com"
ARG BOARD_DIR
ARG ANDROID_OUT=/tmp/android_out
ARG OPT_PATH="/usr/local"
ARG ANDROID_LUNCH_COMBO="full_tango4tv-userdebug"
ARG GIT_VERSION="2.9.4"

RUN bash -c 'if [[ -z $BOARD_DIR  ]]; then echo -e "\033[0;31mNO PATCH DIRECTORY, set --build-arg BOARD_DIR=<bord directory path>\033[0m"; exit 1; fi'

# Set lang env
ENV LANG en_US.UTF-8
RUN locale-gen $LANG

# Install essential utils
RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc unzip wget \ 
  python realpath autogen tcl gettext openjdk-7-jdk libcurl4-openssl-dev rsync

# Add build directories 

#RUN bash -c "if ! [ -f $OPT_PATH/opt ]; then mkdir $OPT_PATH/opt ; fi"

RUN mkdir -p "$OPT_PATH"/opt
# RUN mkdir -p "$OPT_PAATH"/opt/android

ADD start_build.sh $OPT_PATH/opt/start_build.sh
ADD $BOARD_DIR $OPT_PATH/android_patch

# openjdk-8
#RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre-headless_8u45-b14-1_amd64.deb
#0f5aba8db39088283b51e00054813063173a4d8809f70033976f83e214ab56c0 sha256
#RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jre_8u45-b14-1_amd64.deb
##9ef76c4562d39432b69baf6c18f199707c5c56a5b4566847df908b7d74e15849 sha256
#RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/o/openjdk-8/openjdk-8-jdk_8u45-b14-1_amd64.deb
##6e47215cf6205aa829e6a0a64985075bd29d1f428a4006a80c9db371c2fc3c4c  sha256
#RUN dpkg -i $(ls | grep '\.deb') | echo " "
#RUN apt-get update
#RUN sudo apt-get -f install

# openjdk-7
# RUN apt-get install -y openjdk-7-jre

# install git
RUN cd /root
RUN wget https://www.kernel.org/pub/software/scm/git/git-"$GIT_VERSION".tar.gz
RUN tar -xvzf git-"$GIT_VERSION".tar.gz
RUN cd git-"$GIT_VERSION" && ./configure && make -j$(cat /proc/cpuinfo | grep processor | wc -l) && make install

# configure USB
RUN wget -S -O - http://source.android.com/source/51-android.txt | sed "s/<username>/root/" | \ 
    tee >/dev/null /etc/udev/rules.d/51-android.rules; \
    udevadm control --reload | echo ""
#DUMMY here TODO fix udevadm control rules

# install repo
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
RUN chmod a+x /usr/bin/repo
#TODO configure repo
# git config
RUN git config --global user.email "$USER_EMAIL"
RUN git config --global user.name "$USER_NAME"

#download android
#RUN mkdir -p "$OPT_PATH/opt/android"
#RUN sync
#RUN ls -la "$OPT_PATH/opt/android"
#RUN cd "$OPT_PATH/opt/android"
#RUN pwd
#RUN bash -c 'repo init -u https://android.googlesource.com/platform/manifest -b android-6.0.1_r10'
#RUN repo sync
#RUN echo -e "\033[0;32mAndroid downloaded OK\033[0m"

# apply sigma patch
#RUN cd $OPT_PATH/android_patch && ./runme.bash $OPT_PATH/android

#using separate output directory
RUN export OUT_DIR_COMMON_BASE=$OUTPUT_DIR
#(Go to Android directory)
RUN export ANDROID_PATH=$OPT_PATH/android
#export JAVA_HOME= # Need setup your own OPEN JDK/JRE 1.7.x PATH
#(e.g. export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/)
#export ANDROID_JAVA_HOME=$JAVA_HOME

# start build
#RUN cd "$OPT_PATH"/android
#RUN source build/envsetup.sh
#RUN lunch "$ANDROID_LUNCH_COMBO"

RUN "$OPT_PATH"/opt/start_build.sh "$ANDROID_OUT" "$OPT_PATH" "USER_NAME" "USER_MAIL"

RUN ls -la "$OPT_PATH"
RUN ls -la "$OPT_PATH/opt"

#VOLUME "$OPT_PATH/opt/android"
#VOLUME "$ANDROID_OUT"
