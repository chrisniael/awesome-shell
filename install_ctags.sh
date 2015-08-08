#!/bin/bash
# +---------------------------------+
# | @file install_ctags.sh            |
# | @author 沈煜, shenyu@shenyu.me  |
# | @brief 一键安装Ctags             |
# | @date 2015/08/08                |
# +---------------------------------+

set -e

CTAGS_VERSION=ctags-5.8
CTAGS_TAR_FILE=$CTAGS_VERSION.tar.gz
CTAGS_DOWNLOAD_URL=http://prdownloads.sourceforge.net/ctags/$CTAGS_TAR_FILE
CTAGS_DIR=$CTAGS_VERSION


# 下载ctags
curl -L $CTAGS_DOWNLOAD_URL -o $CTAGS_TAR_FILE

tar xf $CTAGS_TAR_FILE

cd $CTAGS_DIR/

./configure
make
sudo make install

echo "install ctags success"
