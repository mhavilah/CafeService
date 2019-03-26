#!/bin/bash
#################
#
# Stop Wiremock Server
#
# Usage:
#      ./shutdown-wiremock.sh
#
# As per:
# http://wiremock.org/docs/running-standalone/
#
############################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PORT=8888
BASE_URL=http://localhost:$PORT

echo Shutting down Wiremock on port: $PORT
curl -X POST -s -o - $BASE_URL/__admin/shutdown

sleep 1 

echo Checking for process....
WM_PID=$( ps -ef | grep java | grep wiremock| awk '{ print $1 }' )

if [[ "$WM_PID" == "" ]]
then
	echo Wiremock is down
else
	echo Wiremock PID: $WM_PID
fi
