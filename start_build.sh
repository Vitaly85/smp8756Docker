#!/bin/bash
OUTPUT_DIR=$1
OPT_PATH=$2
USER_NAME=$3
USER_MAIL=$4

#if [[ ${#USER_NAME} > 0 ]]
#then
#USER_NAME=root
#fi

#if [[ ${#USER_MAIL} > 0 ]]
#then
#USER_MAIL="root@mail"
#fi

#git config --global user.email "$USER_MAIL"
#git config --global user.name "$USER_NAME"
echo "####################"
echo start installing repo:
echo "####################"
mkdir -p "$OPT_PATH/opt/android"
cd "$OPT_PATH/opt/android"
repo init -u https://android.googlesource.com/platform/manifest -b android-6.0.1_r10
repo sync
echo "####################"
echo Apply patches:
echo "####################"
cd $OPT_PATH/android_patch 
./runme.bash $OPT_PATH/opt/android
echo -e "\033[0;33mPatches have been applied OK\033[0m"
#using separate output directory
#export OUT_DIR_COMMON_BASE=$OUTPUT_DIR
#(Go to Android directory)
#export ANDROID_PATH=$HOME/android
#export JAVA_HOME= # Need setup your own OPEN JDK/JRE 1.7.x PATH
#(e.g. export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/)
#export ANDROID_JAVA_HOME=$JAVA_HOME

#building Android
cd $OPT_PATH/opt/android
source build/envsetup.sh

#TODO user config here
lunch full_tango4tv-userdebug

export USER=$USER_NAME

makei -j$(cat /proc/cpuinfo | grep processor | wc -l)

#make otapackage
