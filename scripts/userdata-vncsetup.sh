#!/bin/bash
################################################################################
# Userdata script to install and configure VNC server on a Fedora 23+ Server.
# Expects 2 passwords for each of the following
# - VNC Password: used to access VNC Service (Argument-1)
# - User password: user password for login to GUI (Argument-2)
# Configure background job to execute vncsetup.sh as a separate process
################################################################################
# Author: Jayan (jayan@reancloud.com)
################################################################################

# Variable definitions
## Grab passwords from command line arguments
vncPassword="$1"
userPassword="$2"

# Install required packages
dnf -y install at
atd
sleep 10
ps -ef |grep atd > /tmp/pgrep-atd.log


# Download vncsetup.sh
# Make syre vncsetup.sh is publicly accessible and update the location below
mkdir /tmp/vncsetup
curl https://raw.githubusercontent.com/brennv/aws-quickstart-openshift/master/scripts/vncsetup.sh -o /tmp/vncsetup/vncsetup.sh
chmod a+x /tmp/vncsetup/vncsetup.sh

# SELinux -> Permissive mode for running 'at'
# Make sure the at job enables SELinux back
setenforce 0

# Schedule a job 2 minutes from NOW
echo "bash -x /tmp/vncsetup/vncsetup.sh ${vncPassword} ${userPassword} &> /var/log/vncsetup.log" |at now + 2 min
