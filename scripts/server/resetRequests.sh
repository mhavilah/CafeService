#!/bin/bash
#################
#
# Reset Wiremock Request Journal 
#
# Usage:
#      ./resetRequests.sh
#
# As per:
# http://wiremock.org/docs/running-standalone/
#
############################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PORT=8888
BASE_URL=http://localhost:$PORT

WM_PS=$(ps -ef | grep java | grep wiremock)

if [[ "$WM_PS" == "" ]]
then
	echo Wiremock is down
	return 1 2>/dev/null || exit 1
else
	echo Wiremock is up 
	echo Clearing request journal: 
	curl -X DELETE -s -o - $BASE_URL/__admin/requests
	return 0 2>/dev/null || exit 0
fi
