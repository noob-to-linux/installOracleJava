#installOracleJava
Bash shell script to download and install Oracle JDK on 64bit x86 platforms only, and configure java and javac alternatives.
#
Installer script for Oracle Java written by Biju C.
Date written: 01/06/2022
Usage: sudo ./installOracleJava.sh <JDK version>
<JDK version> substitute with the desired JDK version, when no argument is passed, defaults to JDK 18.
- sudo privilege required
- Installs JDK using apt install
- Sets up alternatives for java and javac
- Deletes the downloaded installation file
#
**Disclaimer:** This is my very first attempt at a bash shell script, and this script is provided as is without any guarantess that this works. This shell script was written based on steps I followed to install Oracle java manually on ubuntu linux 22.04, which was based on different online sources. The shell script essentially replicates the manual steps and has only been tested on two of my ubuntu 22.04 machines. Please use at your own risk.
