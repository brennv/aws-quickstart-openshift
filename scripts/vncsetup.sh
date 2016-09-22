#!/bin/bash
################################################################################
# Script to install and configure VNC server on a Fedora 23+ Server.
# Expects 2 passwords for each of the following
# - VNC Password: used to access VNC Service (Argument-1)
# - User password: user password for login to GUI (Argument-2)
################################################################################
# Author: Jayan (jayan@reancloud.com)
################################################################################

# Variable definitions
## Grab passwords from command line arguments
vncPassword=${1}
userPassword=${2}

# Install VNC Server and dependancies
dnf -y install @basic-desktop-environment firefox gdm tigervnc-server switchdesk system-switch-displaymanager

# Configure VNC server
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@.service
sed -i 's/<USER>/fedora/' /etc/systemd/system/vncserver@.service
sed -i 's/multi-user.target/graphical.target/' /etc/systemd/system/vncserver@.service
systemctl daemon-reload

# Setup VNC Password
mkdir ~fedora/.vnc
echo ${vncPassword} | vncpasswd -f > ~fedora/.vnc/passwd
chown -R fedora.fedora ~fedora/.vnc
chmod 600 ~fedora/.vnc/passwd

# Configure GNOME-Desktop
switchdesk GNOME
system-switch-displaymanager gdm
systemctl set-default graphical.target
rm -rf /tmp/.X11-unix &> /dev/null
echo ${userPassword} | passwd fedora --stdin

# Configure firewall
systemctl start iptables
service firewalld start
firewall-cmd --zone=public --add-port=5900-5910/tcp
# systemctl stop firewalld
# systemctl disable firewalld
# systemctl mask firewalld

# Enable and start GUI and VNC Service
systemctl isolate graphical.target
systemctl enable vncserver@:1.service
systemctl restart vncserver@:1.service

# SELinux -> Enforce mode
setenforce 1

# Send cfnsignal if urlfile located under /tmp/userdata/cfn-signal.url
[ -f /tmp/userdata/cfn-signal.url ] && cfn-signal -s 1 -e 0 "$(cat /tmp/userdata/cfn-signal.url)"
