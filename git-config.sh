#!/bin/bash
# @file ssh-keys-gen.sh
# @author 沈煜, shenyu@shenyu.me
# @brief 一键配置git
# @date 2015/07/31

set -e

echo -n "Please input your name: "
read name

echo -n "Please input your email: "
read email


echo $name
echo $email

git config --global user.name "$name"
git config --global user.email $email

# 颜色配置
git config --global color.branch auto
git config --global color.diff auto
git config --global color.grep auto
git config --global color.interactive auto
git config --global color.status auto
git config --global color.showbranch auto
git config --global color.ui auto
git config --global color.decorate auto

# 默认编辑器
git config --global core.editor vim
