#!/bin/bash
#################
#
# Run Wiremock Server
#
# Usage:
#      ./wiremock.sh [port]
#
# As per:
# http://wiremock.org/docs/running-standalone/
#
# Files to serve are under: __files
# URL Mappings are spec'd in: mappings/*.json
#
############################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

usage ()
{
cat <<EOM
#################
#
# Run Wiremock Server
#
# Usage:
#      ./wiremock.sh [port]
#
# As per:
# http://wiremock.org/docs/running-standalone/
#
# Files to serve are under: __files
# URL Mappings are spec'd in: mappings/*.json
#
#################
EOM
}

if [[ $# != 1 ]]
then
	usage
	return 1 2>/dev/null || exit 1
fi

PORT=$1
BASE_URL=http://localhost:$PORT

WIREMOCK_JAR=wiremock-standalone-2.19.0.jar
WIREMOCK_DIR=$DIR/lib

if [[ ! -f $WIREMOCK_DIR/$WIREMOCK_JAR && ! -L $WIREMOCK_DIR/$WIREMOCK_JAR ]]
then
	echo Cannot find Wiremock: $WIREMOCK_DIR/$WIREMOCK_JAR
	echo Exiting...
	return 1 2>/dev/null || exit 1
fi

#
# Check process
#
if [[ $(ps -ef | grep java | grep wiremock | grep $PORT | grep -v grep) != "" ]]
then
	echo Wiremock is already up.
	return 1 2>/dev/null || exit 1
fi

echo Starting wiremock on port: $PORT...

java -classpath $WIREMOCK_DIR -jar $WIREMOCK_DIR/$WIREMOCK_JAR --port $PORT --local-response-templating --print-all-network-traffic --root-dir $DIR &
# http://wiremock.org/docs/running-standalone/
# --match-headers: ...
# --global-response-templating -  Render all response definitions using Handlebars templates.
# --local-response-templating - Enable rendering of response definitions using Handlebars templates for specific stub mappings.
# --print-all-network-traffic

sleep 2
echo Registered mappings:

curl -X GET -s -o - $BASE_URL/__admin/mappings | jq .
