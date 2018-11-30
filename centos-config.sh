#!/bin/bash

VIM_VERSION=8.1.0516
MYSQL_ROOT_PASSWD=123456
REDIS_PASSWD=123456

function judge_user()
{
  if [ $(whoami) != "root" ]
  then
    echo "Error: Please run the shell script with root."
    exit 1
  fi
}

function judge_system()
{
	if [ ! -f /etc/centos-release ]
	then
		echo "Error: Only support CentOS 7."
		exit 1
	fi

	grep "CentOS Linux release 7" /etc/centos-release
	if [ ! $? -eq 0 ]
	then
		echo "Error: Only support CentOS 7."
		exit 1
	fi
}

function yum_install()
{
  yum update -y

  yum install -y deltarpm

  yum install -y epel-release \
								 centos-release-scl 

  yum install -y passwd \
                 openssl \
                 openssh-server \
                 protobuf-devel \
                 protobuf-lite \
                 protobuf-lite-devel \
                 gperftools-devel \
                 mariadb-server \
                 mariadb-devel \
                 libcurl-devel \
                 cmake3 \
                 htop \
                 net-tools \
                 zsh \
                 telnet \
                 wget \
                 ack \
                 colordiff \
                 ctags \
                 redis \
                 hiredis-devel \
                 nodejs \
                 the_silver_searcher \
                 devtoolset-7 \
                 llvm-toolset-7 \
                 sclo-git212-git \
                 gitflow \
                 lrzsz \
                 bash-completion \
                 bind-utils \
                 devtoolset-7-libstdc++-docs

	ln -s /usr/bin/cmake3 /bin/cmake
}

# 安装 vim 8
function install_vim8()
{
  yum install -y gcc gcc-c++ cmake3 ruby ruby-devel lua lua-devel ctags git \
    python python-devel tcl-devel ncurses-devel perl perl-devel \
    perl-ExtUtils-ParseXS perl-ExtUtils-CBuilder perl-ExtUtils-Embed

  wget https://github.com/vim/vim/archive/v${VIM_VERSION}.tar.gz
  tar xvf v${VIM_VERSION}.tar.gz
  cd vim-${VIM_VERSION}

  ./configure --with-features=huge \
              --enable-multibyte \
              --enable-rubyinterp=yes \
              --enable-pythoninterp=yes \
              --with-python-config-dir=/usr/lib64/python2.7/config \
              --enable-perlinterp=yes \
              --enable-luainterp=yes \
              --enable-cscope \
              --prefix=/usr/local

  make
  make install
}

# 安装 mycli
function install_mycli()
{
  yum install -y python2-pip
  #pip install --upgrade setuptools
  pip install mycli
}

function config_mariadb()
{
	systemctl start mariadb
	systemctl enable mariadb

		# 设置 mysql 密码
		mysqladmin -u root password "$MYSQL_ROOT_PASSWD"
	}

function config_redis()
{
	# 设置 redis 密码
	sed -i "/^[[:space:]]*requirepass/d" /etc/redis.conf
	sed -i "/^#[[:space:]]*requirepass/a requirepass $REDIS_PASSWD" /etc/redis.conf

	systemctl start redis
	systemctl enable redis
}

function config_core_dump()
{
  echo "core-%e-%p-%t" > /proc/sys/kernel/core_pattern
}

## 程序开始执行处，上面是定义
set -e

judge_user
judge_system

yum_install
install_vim8
install_mycli

config_mariadb
config_redis
config_core_dump
