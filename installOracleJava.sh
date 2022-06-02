#!/bin/bash
#-------------------------------------------------------------------------------------------------------------------------
# Installer script for Oracle Java written by Biju C.
# Date written: 01/06/2022
# Usage: sudo ./installOracleJava.sh <JDK version>
# <JDK version> substitute with the desired JDK version, when no argument is passed, defaults to JDK 18.
# - sudo privilege required
# - Installs JDK using apt install
# - Sets up alternatives for java and javac
# - Deletes the downloaded installation file
#-------------------------------------------------------------------------------------------------------------------------
URLPREF="https://download.oracle.com/java/"
URLSUFF="/latest/"
JDK="jdk-"
JDKSUFF="_linux-x64_bin.deb"
REQ_ARCH="x86_64"
DEF_JAVA_VER="18"
#
JAVA_VER=$1
if [ $# = 0 ];
then
   echo "Inf[I0001]:No JDK version provided when invoking script."
   echo "Inf[I0001]:Defaulting installer to JDK version $DEF_JAVA_VER."
   JAVA_VER=$DEF_JAVA_VER
else
   if [ $1 < DEF_JAVA_VER ];
   then
      echo "Err[E0001]:This installer supports JDK18 or higher only."
      echo "Err[E0001]:Terminating..."
      exit 1
   fi
fi
#
# Check and ensure OS is 64bit, else terminate.
#
SYS_ARCH=$(uname -m)
if [ $REQ_ARCH != $SYS_ARCH ];
then
   echo "Err[E0002]:This JDK installer only supports 64bit architecture."
   echo "Err[E0002]:This system architecture is $SYS_ARCH."
   echo "Err[E0002]:Terminating..."
   exit 1
fi
#
# Build JDK download url
#
DOWNLOAD_FILE="${JDK}${JAVA_VER}${JDKSUFF}"
DOWNLOAD_URL="${URLPREF}${JAVA_VER}${URLSUFF}${DOWNLOAD_FILE}"
echo "Inf[I0002]:Downloading JDK from $DOWNLOAD_URL."
DOWNLOAD_RESP=$(wget -q $DOWNLOAD_URL)
if [ $? != 0 ];
then
   echo "Err[E0003]:JDK download failed."
   echo "Err[E0003]:javaJDK download url '$DOWNLOAD_URL'."
   echo "Err[E0003]:Please check wget output below for more information."
   wget $DOWNLOAD_URL
   echo "Err[E0003]:Terminating..."
   exit 1
fi
#
FILE_LIST=$(ls)
if [ $? != 0 ];
then
   echo "Err[E0004]:ls command failed."
   echo "Err[E0004]:Terminating..."
   exit 1
fi
#
if [[ $FILE_LIST == *"$DOWNLOAD_FILE"* ]];
then
   echo "Inf[I0003]:Downloaded JDK successfully..."
   sudo apt install ./$DOWNLOAD_FILE
   if [ $? != 0 ];
   then
      echo "Err[E0005]:Installation (apt install) failed, verify above errors for more details."
      echo "Err[E0005]:Terminating..."
      exit 1
   else
      echo "Inf[I0004]:JDK $JAVA_VER installation completed successfully."
      echo "Inf[I0004]:Cleaning up installation file..."
      rm -v $DOWNLOAD_FILE
      echo  "Inf[I0005]:Setting java alternatives."
      sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-$JAVA_VER/bin/java 1
      if [ $? = 0 ];
      then
         echo  "Inf[I0005]:Done."
         echo  "Inf[I0006]:Setting javac alternatives."
         sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-$JAVA_VER/bin/javac 1
         if [ $? = 0 ];
         then
            echo  "Inf[I0006]:Done."
         else
            echo "Err[E0006]:Setting javac alternatives failed, verify previous messages for more details."
            echo "Err[E0006]:Terminating..."      
            exit 1      
         fi
      else
         echo "Err[E0007]:Setting java alternatives failed, verify previous messages for more details."
         echo "Err[E0007]:Terminating..."
         exit 1
      fi
   fi
else
   echo "Err[E0008]:JDK installation file $DOWNLOAD_FILE not found."
   echo "Err[E0008]:Terminating..."
   exit 1
fi
#
echo "Inf[I0007]:All tasks completed successfully."
echo "Inf[I0007]:Oracle JDK $JAVA_VER installed and configured successfully."
