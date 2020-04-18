#!/bin/bash

# urlencode/urldecode is forked from https://gist.github.com/cdown/1163649
urlencode() {
  if [[ $# != 1 ]]; then
    echo "Usage: $0 string-to-urlencode"
    return 1
  fi
  local data=$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "$1" "")
  if [[ $? == 0 ]]; then
    echo "${data##/?}"
  fi
  return 0
}

hex2dec() {
  local hex=$1
  local dec=$[16#$hex]
  echo $dec
}

dec2ch() {
  local dec=$1
  local ch=$(printf "\x$(printf %x $dec)")
  echo $ch
}


# Cloudflare 邮箱混淆技术
# https://blog.shiniv.com/2016/09/decode-encode-cloudflare-address-obfuscation/
# https://support.cloudflare.com/hc/en-us/articles/200170016-What-is-Email-Address-Obfuscation-
decode_email() {
  local cfcode=$1
  # echo $cfcode
  local key=$(hex2dec ${cfcode:0:2})
  # echo $key
  local real_email=
  for ((i=2; i < ${#cfcode}; i=i+2))
  do
    hex=${cfcode:$i:2}
    dec=$(hex2dec $hex)
    ch=$(dec2ch $(($dec ^ $key)))
    # echo $i $hex $dec $ch
    real_email="${real_email}${ch}"
  done
  echo -n $real_email
}


url="https://appledi.com"
encode_data=$(curl -s https://appledi.com | grep 免费分享账号 | grep -Eo "data-cfemail=\".+?\"" | awk -F '"' '{print $2}')
# echo $encode_data
real_email=$(decode_email $encode_data)
passwd=$(curl -s https://appledi.com | grep 免费分享账号 | grep -Eo "密码：.+? " | awk -F '：' '{print $2}')
printf "${real_email}\t${passwd}\n"

# https://raw.githubusercontent.com/wiki/shadowrocketHelp/help/国外-appstore-id-账号分享.md"
url="https://raw.githubusercontent.com/wiki/shadowrocketHelp/help/$(urlencode '国外-appstore-id-账号分享.md')"
url_html=$(curl -fsSL $url)
echo $url_html | grep -Eo "【2】美区 apple id 账号：\`.+?\`" | awk -F '`' '{printf $2"\t"}'
echo $url_html | grep -Eo "【2】美区 apple id 密码：\`.+?\`" | awk -F '`' '{print $2}'

# https://raw.githubusercontent.com/wiki/91CL/91CL-VPN/美区AppleID免费共享.md
url="https://raw.githubusercontent.com/wiki/91CL/91CL-VPN/$(urlencode '美区AppleID免费共享.md')"
url_html=$(curl -fsSL $url)
echo $url_html | grep -Po "免费分享账号：.+?密码：[^ ]+ " | awk -F '[： ]' '{print $2"\t"$4}'
