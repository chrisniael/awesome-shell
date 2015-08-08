#!/bin/bash
# +---------------------------------+
# | @file git-jekyll.sh             |
# | @author 沈煜, shenyu@shenyu.me  |
# | @brief 安装jekyll               |
# | @date 2015/08/08                |
# +---------------------------------+

set -e

TAOBAO_RUBY_SOURCE=https://ruby.taobao.org/
OFFICIAL_RUBY_SOURCE=https://rubygems.org/

gem sources -a $TAOBAO_RUBY_SOURCE
gem sources --remove $OFFICIAL_RUBY_SOURCE
sudo gem install jekyll -V

echo "done"
