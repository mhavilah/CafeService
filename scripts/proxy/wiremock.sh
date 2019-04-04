#!/bin/bash
#################
#
# Run Wiremock Server
#
# Usage:
#      ./wiremock.sh
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

WIREMOCK_JAR=wiremock-standalone.jar

if [[ ! -f $DIR/$WIREMOCK_JAR && ! -L $DIR/$WIREMOCK_JAR ]]
then
	echo Cannot find Wiremock: $DIR/$WIREMOCK_JAR
	echo Exiting...
	return 1 2>/dev/null || exit 1
fi

#
# Check process
#
if [[ $(ps -ef | grep java | grep wiremock | grep -v grep) != "" ]]
then
	echo Wiremock is already up.
	return 1 2>/dev/null || exit 1
fi

echo Starting wiremock on port: $PORT...

java -classpath $DIR -jar $DIR/$WIREMOCK_JAR --port $PORT --local-response-templating --print-all-network-traffic --root-dir $DIR &
# http://wiremock.org/docs/running-standalone/
# --match-headers: ...
# --global-response-templating -  Render all response definitions using Handlebars templates.
# --local-response-templating - Enable rendering of response definitions using Handlebars templates for specific stub mappings.
# --print-all-network-traffic

sleep 2
echo Registered mappings:

curl -X GET -s -o - $BASE_URL/__admin/mappings | jq .
