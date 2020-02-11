#!/bin/bash

# 公司每日上报健康状况，没有状况天天上报个啥？
# 产品差评，很多项不能记录上次填写，
# App 切出去再切回来或者打开或者下拉一下通知栏，所有填写全部清空重来，想摔手机的节奏

# cookie_file=cookie

# user=shenyu.tommy
# passwd=123456
# passwd_md5=$(echo -n $passwd | md5 | tr a-z A-Z)
# echo $passwd_md5

# # 登陆
# curl --silent --cookie-jar $cookie_file --request GET --url https://mwf.corp.sdo.com/WFM/SecretVerify.aspx\?appid\=1614\&userid\=${user}\&password\=${passwd_md5}\&secretcode\=123

# Cookie HEALTH_REPORT_YOUXI2_SID 的值从何而来没有追踪到 Set-Cookie 的响应
# 猜测是某个能标识用户唯一身份的字符串的 md5 值
# 抓了几次包，这个 cookie 值一直没有变过

cookie_sid="md5"
from_location="花村"
comeback_pass_city="努巴尼"
detail_living_addr="漓江塔"

curl --silent \
  --cookie "HEALTH_REPORT_YOUXI2_SID=${cookie_sid}" \
  --request POST \
  --header 'Content-Type: application/json;charset=utf-8' \
  --url https://health.corp.sdo.com/hrapi/hr/clockin \
  --data-raw "{\"workPlace\":\"家里\",\"workPlaceRemarks\":\"\",\"workCityId\":0,\"todayIsWork\":1,\"liveInCity\":\"上海市-上海市-浦东新区\",\"isContactRemarks\":\"\",\"currentLocalCity\":\"上海市-上海市-浦东新区\",\"isContact\":\"均无以上五种情况\",\"inOutShanghai\":{\"comebackTime\":\"2020-2-5\",\"fromLocation\":\"${from_location}\",\"isOutGuonian\":1,\"way\":\"自驾\",\"wayNum\":\"\",\"leaveShanggaiTime\":\"2020-1-23\",\"comebackPassCity\":\"${comeback_pass_city}\"},\"healthStatusRemarks\":\"\",\"healthStatus\":\"良好\",\"floorId\":0,\"feverTemp\":\"\",\"feverIsDoctor\":\"\",\"feverDays\":0,\"coldDays\":0,\"buildingId\":0,\"trafficInfo\":\"\",\"livingStyle\":\"合租\",\"detailLivingAddr\":\"${detail_living_addr}\",\"familyCotenancyType\":\"均无以上四种情况\",\"familyCotenancyIsGeli\":\"是\",\"familyCotenancyGeliEndTime\":\"2020-2-20\",\"commutingMode\":\"自驾(汽车/自行车/电瓶车)\",\"oneCommutingTime\":\"30分钟内\"}"
