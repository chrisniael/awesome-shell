#!/bin/bash

if [ "$USER" != "root" ]
then
  echo "Please run as root"
  exit 1
fi

# load bbr module
modprobe tcp_bbr

# check module 
lsmod | grep bbr

# temp
sysctl -w net.core.default_qdisc=fq
sysctl -w net.ipv4.tcp_congestion_control=bbr

# enable
echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/tcp-bbr.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/tcp-bbr.conf
