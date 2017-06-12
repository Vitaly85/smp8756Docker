
Here is docker for build android for SMP pltforms only
#TODO not finished full, see TODO in scripts

For build android image use:

$ docker build --build-arg BOARD_DIR=android_patcher_path ./

USER_NAME  - used for set git user.name(default="root")
USER_EMAIL - used for set git user.mail(default="root@mail.com" )
BOARD_DIR  - used for set path to directory with board-specific patches(essential!!!) - for SMP only
ANDROID_OUT- path for android image output(default="/tmp/android_out")
OPT_PATH   - path for android opt directory(default="/usr/local")
ANDROID_LUNCH_COMBO - android lunch config(default="full_tango4tv-userdebug")
GIT_VERSION - git version(default="2.12.2")
a.e.
sudo docker build --build-arg BOARD_DIR=android_6_87xx_package_1130 ./
 * here android_6_87xx_package_1130 located in ./ directory near with Dockerfile.
 * android needs lots of memmory(~ 100Gb). Be sure you have enough free memmory for docker
   ( use 
	echo >> "DOCKER_OPTS=\"-g /home/user/docker\" " >> /etc/default/docker && service docker restart
     to swith default docker images path(default=/var/lib/docker) to /home/user/docker )
