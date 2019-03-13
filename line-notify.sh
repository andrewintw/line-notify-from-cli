#! /bin/sh
#
# LINE Doc:     https://engineering.linecorp.com/zh-hant/blog/using-line-notify-to-send-messages-to-line-from-the-command-line/
# Curl Command: curl -X POST -H 'Authorization: Bearer [access_token]' -F 'message=foobar' https://notify-api.line.me/api/notify 
#

# Ex: curl -X POST -H 'Authorization: axNLJsrLOwRZCcJEKCeWlTGcSHbgYffMJjqHOCQatDj' -F 'message=foobar' https://notify-api.line.me/api/notify

access_token='axNLJsrLOwRZCcJEKCeWlTGcSHbgYffMJjqHOCQatDj'	# replace with your personal access token.

NOTIFY_API_URL='https://notify-api.line.me/api/notify'
NOTIFY_API_DOC='https://engineering.linecorp.com/zh-hant/blog/using-line-notify-to-send-messages-to-line-from-the-command-line/'
#IMG_URL='https://stickershop.line-scdn.net/stickershop/v1/sticker/25171929/ANDROID/sticker.png'
IMG_URL='https://stickershop.line-scdn.net/stickershop/v1/sticker/10357056/ANDROID/sticker.png'
notify_message="$1"

is_jq_install=0
is_show_img=1
en_dbg=0

print_dbg () {
	if [ "$en_dbg" = "1" ]; then
		echo "$*"
	fi
}

do_init () {
	if [ "$access_token" = '' ]; then
		cat << EOF

Error: access_token is not defined.
Help:  please change the 'access_token' value in the code.
Info:  $NOTIFY_API_DOC

EOF
		return 1
	fi

	which jq 1>/dev/null && is_jq_install=1 || is_jq_install=0
	print_dbg "debug>> is_jq_install=[$is_jq_install]"

	if [ "$notify_message" = '' ]; then
		notify_message=$(</dev/stdin)
	fi
	
	print_dbg "debug>> notify_message=[$notify_message]"
}

send_notify () {
	# Curl Command: curl -X POST -H 'Authorization: Bearer [access_token]' -F 'message=foobar' https://notify-api.line.me/api/notify
	local ret_json=''
	local ret_st=''
	local ret_msg=''
	local cmd_params=''

	#cmd_params=" -F message=${notify_message} "

	if [ "$is_show_img" = "1" ]; then
		cmd_params+=" -F imageThumbnail=${IMG_URL} -F imageFullsize=${IMG_URL} "
	fi

	#curl -s -X POST -H "Authorization: Bearer $access_token" -F message="${notify_message}" $NOTIFY_API_URL

	ret_json=`curl -s -X POST \
		 -H "Authorization: Bearer $access_token" \
		 -F message="${notify_message}" \
		 ${cmd_params} \
		 $NOTIFY_API_URL`

	print_dbg "debug>> json=[$ret_json]"

	if [ "$ret_json" = "" ]; then
		echo "error>> Failed to connect to notify API server!"
		exit 1
	fi

	if [ "$is_jq_install" = "1" ]; then
		ret_st=`echo $ret_json | jq -r '.status'`
		ret_msg=`echo $ret_json | jq -r '.message'`
	else

		ret_st=`echo $ret_json | sed -e 's/[{}]/''/g' | awk -F ',' '{print $1}' | awk -F ':' '{print $2}'`
		ret_msg=`echo $ret_json | sed -e 's/[{}]/''/g' | awk -F ',' '{print $2}' | awk -F ':' '{print $2}'`

	fi
	print_dbg "debug>> status=[$ret_st] message=[$ret_msg]"
	if [ "$ret_st" != "200" ]; then
		echo "error>> ${ret_msg}"
		exit 1
	fi
}

do_done () {
	echo ""
}

do_main () {
	do_init 	&& \
	send_notify && \
	do_done
}

do_main

