#!/bin/bash
###########################
#
# startProxy.sh
#
# Start a Wiremock recording proxy server
# Records requests to an API and builds
# stub mappings and records response files.
#
# Usage:
#   startProxy.sh [proxyPortNumber] [targetAPI] [key] 
#
# Where:
#   proxyPortNumber is the TCP/IP port at localhost of the Wiremock proxy
#   targetAPI is the remote service to be proxied.
#   key (optional) is an API key that is required for access
#
# Note:
#   If the API key is omitted, an unauthenticated API is assumed.
#   If the API Key is provided, it will be appended to the targetAPI
#    as a path parameter
#
# Examples:
#  startProxy.sh 9000 https://api.willyweather.com.au/v2 
#     Proxies requests to http://localhost:9000 onto the above URL.
# 
#  startProxy.sh 9000 https://api.willyweather.com.au/v2 =Aer3423n?
#     Proxies requests to http://localhost:9000 onto the 
#     API authenticated base URL:  https://api.willyweather.com.au/v2/=Aer3423n?
#
###########################

usage ()
{
cat <<EOM
###########################
#
# startProxy.sh
#
# Start a Wiremock recording proxy server
# Records requests to an API and builds
# stub mappings and records response files.
#
# Usage:
#   startProxy.sh [proxyPortNumber] [targetAPI] [key] 
#
# Where:
#   proxyPortNumber is the TCP/IP port at localhost of the Wiremock proxy
#   targetAPI is the remote service to be proxied.
#   key (optional) is an API key that is required for access
#
# Note:
#   If the API key is omitted, an unauthenticated API is assumed.
#   If the API Key is provided, it will be appended to the targetAPI
#    as a path parameter
#
# Examples:
#  ./startProxy.sh 9000 https://api.willyweather.com.au/v2 
#     Proxies requests to http://localhost:9000 onto the above URL.
# 
#  ./startProxy.sh 9000 https://api.willyweather.com.au/v2 =Aer3423n?
#     Proxies requests to http://localhost:9000 onto the 
#     API authenticated base URL:  https://api.willyweather.com.au/v2/=Aer3423n?
#
############################
EOM
}

if [[ $# -lt 2 ]]
then
	usage
	return 1 2>/dev/null || exit 1
fi

WM_LOCAL_PROXY_PORT=$1
TARGET_API_BASE_URL=$2
if [[ $# == 3 ]]
then
	WM_API_KEY=$3
else
	echo Checking API_KEY env var for API Key...
	if [[ "$API_KEY" != "" ]]
	then
		echo Found API_KEY environment variable.
	fi
	WM_API_KEY=$API_KEY
fi

if [[ "$WM_API_KEY" == "" ]]
then
        echo "Warn: No API KEY Set - assuming anonymous, unauthenticated API"
	TARGET_API_AUTHENTICATED_URL=$TARGET_API_BASE_URL
else
	echo Using authenticated API...
	TARGET_API_AUTHENTICATED_URL=$TARGET_API_BASE_URL/$WM_API_KEY
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

WIREMOCK_JAR=wiremock-standalone-2.19.0.jar
WIREMOCK_DIR=$DIR/lib

if [[ ! -f $WIREMOCK_DIR/$WIREMOCK_JAR && ! -L $WIREMOCK_DIR/$WIREMOCK_JAR ]]
then
	echo Cannot find Wiremock: $WIREMOCK_DIR/$WIREMOCK_JAR
	echo Exiting...
	return 1 2>/dev/null || exit 1
fi

echo Starting Wiremock proxy.
echo Listening on port: $WM_LOCAL_PROXY_PORT
echo Proxying API Service:  $TARGET_API_AUTHENTICATED_URL
echo "API Mappings will be saved under:"
echo "$DIR/mappings"
echo "API Responses will be saved under:"
echo "$DIR/__files"
echo =============================================
echo Requests to: "http://localhost:$WM_LOCAL_PROXY_PORT" will be forwarded to: $TARGET_API_AUTHENTICATED_URL
java -jar $WIREMOCK_DIR/$WIREMOCK_JAR --port $WM_LOCAL_PROXY_PORT --proxy-all="$TARGET_API_AUTHENTICATED_URL" --record-mappings

