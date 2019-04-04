#!/bin/bash
#################
#
# Stop Wiremock Server
#
# Usage:
#      ./shutdown-wiremock.sh [port]
#
# Where:  [port] is optional
#    Defaults to port 8888
#
# As per:
# http://wiremock.org/docs/running-standalone/
#
############################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PORT=8888
if [[ "$1" != "" ]]
then
	PORT=$1
fi

BASE_URL=http://localhost:$PORT

echo Shutting down Wiremock on port: $PORT
curl -X POST -s -o - $BASE_URL/__admin/shutdown

sleep 1 

echo Checking for process....
WM_PID=$( ps -ef | grep java | grep wiremock| grep '\-\-port '$PORT | awk '{ print $1 }' )

if [[ "$WM_PID" == "" ]]
then
	echo Wiremock is down
else
	echo Wiremock PID: $WM_PID
fi
