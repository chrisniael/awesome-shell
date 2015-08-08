#!/bin/bash
# +---------------------------------+
# | @file ssh-keys-gen.sh           |
# | @author 沈煜, shenyu@shenyu.me  |
# | @brief 一键生成ssh-keys         |
# | @date 2015/07/31                |
# +---------------------------------+

set -e

HOME_DIR=~
RSA_PUB_FILE=$HOME_DIR/.ssh/id_rsa.pub
RSA_FILE=$HOME_DIR/.ssh/id_rsa

rsa_pub_file_exist=0
if [ -f $RSA_PUB_FILE ]
then
	rsa_pub_file_exist=1
fi

rsa_file_exist=0
if [ -f $RSA_FILE ]
then
	rsa_file_exist=1
fi

if [ $rsa_pub_file_exist -eq 1 ] && [ $rsa_file_exist -eq 1 ]
then
	echo "ssh keys already exist."
	exit 0
fi

if [ $rsa_pub_file_exist -ne $rsa_file_exist ]
then
	rm -f $RSA_PUB_FILE $RSA_FILE
fi

echo -n "Please input your email: "
read your_email
ssh-keygen -t rsa -b 4096 -P "" -f "/home/shenyu/.ssh/id_rsa" -C "$your_email"

echo "ssh keys generate success."
