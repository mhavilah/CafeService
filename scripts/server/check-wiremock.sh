#!/bin/bash
#################
#
# Check Wiremock Server Health
#
# Usage:
#      ./check-wiremock.sh
#
# As per:
# http://wiremock.org/docs/running-standalone/
#
# Files to serve are under: __files
# URL Mappings are spec'd in: mappings/*.json
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
	echo Registered mappings: 
	curl -X GET -s -o - $BASE_URL/__admin/mappings | jq .
	return 0 2>/dev/null || exit 0
fi
