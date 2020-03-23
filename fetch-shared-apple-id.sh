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

url="https://raw.githubusercontent.com/v2net/Apple/master/README.md"
curl -fsSL $url | grep "免费分享账号" | awk -F '[： ]' '{print $3"\t"$5}'

# https://raw.githubusercontent.com/wiki/shadowrocketHelp/help/国外-appstore-id-账号分享.md"
url="https://raw.githubusercontent.com/wiki/shadowrocketHelp/help/$(urlencode '国外-appstore-id-账号分享.md')"
url_html=$(curl -fsSL $url)
echo $url_html | grep -Eo "【2】美区 apple id 账号：\`.+?\`" | awk -F '`' '{printf $2"\t"}'
echo $url_html | grep -Eo "【2】美区 apple id 密码：\`.+?\`" | awk -F '`' '{print $2}'

# https://raw.githubusercontent.com/wiki/91CL/91CL-VPN/美区AppleID免费共享.md
url="https://raw.githubusercontent.com/wiki/91CL/91CL-VPN/$(urlencode '美区AppleID免费共享.md')"
url_html=$(curl -fsSL $url)
echo $url_html | grep -Po "免费分享账号：.+?密码：[^ ]+ " | awk -F '[： ]' '{print $2"\t"$4}'
