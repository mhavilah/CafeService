#!/bin/bash
##############################
#
# getRain.sh
#
# Direct API request to the WilyWeather API
# without any Wiremock Proxying inbetween.
#
# Retrieves a JSON based weather forecast for
# today's weather.
# 
# Prerequisites:
# - jq  - JSON formatter
# Install via: sudo brew install jq on OSX
# or: sudo apt-get install jq  on Linux
# or: choco install jq on Windows (See: https://chocolatey.org/)
#
# Note:
# Requires an API key to have been setup
# at:
# https://www.willyweather.com.au/info/api.html
#
# Put the key in the setAPIKeyEnv.sh script
#
##############################
DATE=`date +"%Y-%m-%d"`

if [[ `which jq` == "" ]]
then
	echo jq is not installed
	return 1 2>/dev/null || exit 1
fi

if [[ "$API_KEY" == "" ]]
then
	echo No API KEY Set.
	echo Try ./setAPIKeyEnv.sh
	return 1 2>/dev/null || exit 1
fi
curl -X GET -o - "https://api.willyweather.com.au/v2/$API_KEY/locations/2251/weather.json?forecasts=rainfallprobability&days=5&startDate=$DATE" | jq .
