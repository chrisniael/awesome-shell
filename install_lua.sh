#!/bin/bash
# +---------------------------------+
# | @file install_lua.sh            |
# | @author 沈煜, shenyu@shenyu.me  |
# | @brief 一键安装Lua              |
# | @date 2015/08/08                |
# +---------------------------------+

set -e

LUA_VERSION=lua-5.3.1
LUA_TAR_FILE=$LUA_VERSION.tar.gz
LUA_DOWNLOAD_FILE=http://www.lua.org/ftp/$LUA_TAR_FILE
LUA_DIR=$LUA_VERSION

curl -L $LUA_DOWNLOAD_FILE -o $LUA_TAR_FILE

tar zxf $LUA_TAR_FILE

cd $LUA_DIR

make maxosx

sudo make install
