#!/bin/bash
########################
#
# getProxiedRain.sh
#
# This script makes a request to the
# Wily Weather API via the Wiremock Proxy.
# 
#
#
#######################
DATE=`date +"%Y-%m-%d"`

if [[ `ps -ef | grep wiremock | grep 'proxy-all'` == "" ]]
then
	echo Wiremock Proxy is not up
	return 1 2>/dev/null || exit 1
fi

echo Getting weather for: $DATE at Queenscliff
curl -X GET -o - "http://localhost:9000/locations/2251/weather.json?forecasts=rainfallprobability&days=5&startDate=$DATE" | jq .
