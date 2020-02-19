#!/bin/bash

# 公司每日上报健康状况，没有状况天天上报个啥？
# 产品差评，很多项不能记录上次填写，
# App 切出去再切回来或者打开或者下拉一下通知栏，所有填写全部清空重来，想摔手机的节奏

# 用户名和密码
# 用户名域账号全称，不包含域 (SNDA)，例如：shenyu.tommy，
# 密码是域账号的登陆密码，也就是办公室电脑的开机密码，
# 使用用户名密码登陆即信会导致手机端即信退出登陆状态，
# 所以推荐使用 Sid 和 Key 来使用这个脚本，这样手机端也可以保持登陆状态，
# 关于 Sid 和 Key 的获取见下面的描述
user=""
passwd=""

# Sid 和 Key 用于免去登陆流程，这样做可以不剔掉手机客户端的登陆，且可以执行这个脚本，
# 用 HTTP 调试代理工具 (Mac: ProxyMan) 抓一下登陆请求的 Response (https://mwf.corp.sdo.com/WFM/SecretVerify.aspx)，
# 找到 Response 里 Sid 和 Key 这两个数值，填写在下面，
# 确保上面的 user 和 passwd 填空，否则脚本还是会填写的账号密码登陆
login_response_sid=""
login_response_key=""

# 健康信息
liveInCity="上海市-上海市-浦东新区"  # 您现在居住的城市
todayIsWork=1  # 您今日是否办公，1：是，0：否
workPlace="家里"  # 您今日的办公地点，可选值：公司，家里，其他
currentLocalCity="上海市-上海市-浦东新区"  # 您现在的办公城市
isContact="均无以上五种情况"  # 您是否存在以下情况
healthStatus="良好"  # 您的今日健康状况
isOutGuonian=1  # 春节期间是否离沪
leaveShanggaiTime="2020-01-23 00:00:00" # 离沪日期
fromLocation="江苏省-南通市"  # 您从哪里返沪
comebackTime="2020-2-5"  # 返沪日期
way="自驾"  # 返沪方式
comebackPassCity="南通"  # 中途停留城市
livingStyle="合租"  # 您现在的居住方式
detailLivingAddr="上海"  # 您所在工作城市的居住地址
familyCotenancyType="均无以上四种情况"  # 您的家庭成员/合租人是否存在以下情况？如本人居住，则选择均无以上四种情况
familyCotenancyIsGeli="是"  # 您的家庭成员/合租人员是否处于自我隔离期？如本人居住，择选否
familyCotenancyGeliEndTime="2020-2-20"  # 您的家庭成员/合租人员隔离期何时结束？
commutingMode="自驾(汽车/自行车/电瓶车)"  # 您日常的通勤方式
oneCommutingTime="30分钟内"  # 您日程的单程通勤时间



if [ -n "${user}" ] && [ -n "${passwd}" ]
then
  echo "登陆即信..."
  passwd_md5=$(echo -n $passwd | md5sum | awk -F ' ' '{print $1}' | tr a-z A-Z)
  # echo $passwd_md5
  login_response=$(curl --silent \
    --request GET \
    --url "https://mwf.corp.sdo.com/WFM/SecretVerify.aspx?appid=1614&userid=${user}&password=${passwd_md5}&secretcode=123")

  # echo $login_response

  login_response_result=$(echo $login_response | awk -F ',' '{print $1}' | awk -F ':' '{print $2}')
  # echo $login_response_result
  if [ "$login_response_result" != "1" ]
  then
    login_response_message=$(echo $login_response | awk -F ',' '{print $2}' | awk -F '"' '{print $4}')
    echo "Error: ${login_response_message}"
    exit 1
  else
    echo "成功."
  fi

  login_response_sid=$(echo $login_response | awk -F ',' '{print $3}' | awk -F '"' '{print $4}')
  # echo $login_response_sid
  login_response_key=$(echo $login_response | awk -F ',' '{print $4}' | awk -F '"' '{print $4}')
  # echo $login_response_key
  login_response_ticket=$(echo $login_response | awk -F ',' '{print $5}' | awk -F '"' '{print $4}')
  # echo $login_response_ticket
fi

if [ -z "${login_response_sid}" ] || [ -z "${login_response_key}" ]
then
  echo "Error: 请填写 (user, passwd) 或者 (sid, key)"
  exit 1
fi

function get_sign() {
  # 别在这里 echo 调试信息，会影响函数返回值
  echo -n "${1}${login_response_key}" | md5sum | awk -F ' ' '{print $1}' | tr a-z A-Z
}

echo "生成新票据..."
sleep 2
params="appid=1614&sid=${login_response_sid}"
# echo $params
sign=$(get_sign $params)
# echo $sign
new_ticket_response=$(curl --silent \
  --request GET \
  --url "https://mwf.corp.sdo.com/WFM/GetTicketNew.aspx?${params}&sign=${sign}")
# echo $new_ticket_response
new_ticket_response_result=$(echo $new_ticket_response | awk -F ',' '{print $1}' | awk -F ':' '{print $2}')
# echo $new_ticket_response_result
if [ "$new_ticket_response_result" != "1" ]
then
  new_ticket_response_message=$(echo $new_ticket_response | awk -F ',' '{print $2}' | awk -F '"' '{print $4}')
  echo "Error: ${new_ticket_response_message}"
  exit 1
else
  echo "成功."
fi
new_ticket_response_ticket=$(echo $new_ticket_response | awk -F ',' '{print $3}' | awk -F '"' '{print $4}')
# echo $new_ticket_response_ticket


echo "登陆健康上报系统..."
sleep 1
cookie_file=$(mktemp)
params="appid=1614&sid=${login_response_sid}&ticket=${new_ticket_response_ticket}"
# echo $params
sign=$(get_sign $params)
# echo $sign
health_login_response=$(curl --silent \
  --cookie-jar $cookie_file \
  --request GET \
  --url "https://health.corp.sdo.com/hrapi/user/mobileAuth?${params}&sign=${sign}")
# echo $health_login_response
health_login_response_code=$(echo $health_login_response | grep -E -o '"code":([0-9])+' | awk -F ':' '{print $2}')
# echo $health_login_response_code
if [ "$health_login_response_code" != "0" ]
then
  echo "Error: 登陆健康上报系统失败"
  /bin/rm -f $cookie_file
  exit 1
else
  echo "成功."
fi


echo "上报健康信息..."
sleep 2
health_report_response=$(curl --silent \
  --location \
  --cookie $cookie_file \
  --cookie-jar $cookie_file \
  --request POST \
  --url "https://health.corp.sdo.com/hrapi/hr/clockin" \
  --header 'Content-Type: application/json;charset=utf-8' \
  --data-raw "{\"workPlace\":\"${workPlace}\",\"workPlaceRemarks\":\"\",\"workCityId\":0,\"todayIsWork\":${todayIsWork},\"liveInCity\":\"${liveInCity}\",\"isContactRemarks\":\"\",\"currentLocalCity\":\"${currentLocalCity}\",\"isContact\":\"${isContact}\",\"inOutShanghai\":{\"comebackTime\":\"${comebackTime}\",\"fromLocation\":\"${fromLocation}\",\"isOutGuonian\":${isOutGuonian},\"way\":\"${way}\",\"wayNum\":\"\",\"leaveShanggaiTime\":\"${leaveShanggaiTime}\",\"comebackPassCity\":\"${comebackPassCity}\"},\"healthStatusRemarks\":\"\",\"healthStatus\":\"${healthStatus}\",\"floorId\":0,\"feverTemp\":\"\",\"feverIsDoctor\":\"\",\"feverDays\":0,\"coldDays\":0,\"buildingId\":0,\"trafficInfo\":\"\",\"livingStyle\":\"${livingStyle}\",\"detailLivingAddr\":\"${detailLivingAddr}\",\"familyCotenancyType\":\"${familyCotenancyType}\",\"familyCotenancyIsGeli\":\"${familyCotenancyIsGeli}\",\"familyCotenancyGeliEndTime\":\"${familyCotenancyGeliEndTime}\",\"commutingMode\":\"${commutingMode}\",\"oneCommutingTime\":\"${oneCommutingTime}\"}")
# echo $health_report_response
health_report_response_code=$(echo $health_report_response | grep -E -o '"code":([0-9])+' | awk -F ':' '{print $2}')
# echo $health_report_response_code
if [ "$health_report_response_code" != "0" ]
then
  health_report_response_errmsg=$(echo $health_report_response | grep -E -o '"errMsg":"(.)*?"' | awk -F ':' '{print $2}')
  echo "Error: ${health_report_response_errmsg}" 
  /bin/rm -f $cookie_file
  exit 1
else
  echo "成功."
fi

/bin/rm -f $cookie_file
