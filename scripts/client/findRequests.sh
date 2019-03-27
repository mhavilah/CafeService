#!/bin/bash
#################
#
# Find Journalled Requests from Wiremock 
#
# Queries the Wiremock request history for
# recently received requests based on a URL or URL Pattern criteria.
#
# Usage:
#      ./findRequests.sh [urlQueryPattern]
# Or
#      ./findRequests.sh [urlQueryPattern] -v
# For verbose mode
#
# Example:
#      ./findRequests.sh /order
#      ./findRequests.sh /order/status
#      ./findRequests.sh /order/.*/status
#
# As per:
# http://wiremock.org/docs/verifying/
#
############################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PORT=8888
BASE_URL=http://localhost:$PORT
URL_PATH=__admin/requests/find

usage ()
{
cat <<EOM
#################
#
# Find Journalled Requests from Wiremock
#
# Queries the Wiremock request history for
# recently received requests based on a URL or URL Pattern criteria.
#
# Usage:
#      ./findRequests.sh [urlQueryPattern]
# Or
#      ./findRequests.sh [urlQueryPattern] -v
# For verbose mode
#
# Example:
#      ./findRequests.sh /order
#      ./findRequests.sh /order/.*
#      ./findRequests.sh /order/.*/status
#
# As per:
# http://wiremock.org/docs/verifying/
#
############################
#
# Adding a '*' enables regex mode
EOM

}

if [[ $# -lt 1 ]]
then
	usage
	return 1 2>/dev/null || exit 1
fi

QUERY_PATTERN=$1

if [[ $# == 2 && "${@: -1}" == "-v" ]]
then
	IS_VERBOSE=true
fi

if [[ $IS_VERBOSE == true ]]; then echo Checking for WM process....;
fi
WM_PS=$(ps -ef | grep java | grep wiremock)
if [[ "$WM_PS" == "" ]]
then
	echo Wiremock is down
	echo Exiting...
	return 1 2>/dev/null || exit 1
fi

if [[ $IS_VERBOSE == true ]] ; then echo "Querying Wiremock on port: $PORT"; echo URL Path: $URL_PATH
fi

#
# Build query payload
#

# GET or POST ?
cat <<EOM >queryPayload.json
{
	"method":"ANY",
EOM

if [[ "$QUERY_PATTERN" =~ ^.*\*.*$ ]]
then
	echo 	-n  "\"urlPattern\": "  >>queryPayload.json
else
	echo 	-n   "\"url\": " >>queryPayload.json
fi

echo  "\"$QUERY_PATTERN\"" >>queryPayload.json
echo } >>queryPayload.json

curl -X POST -s --data @queryPayload.json -o - $BASE_URL/$URL_PATH | jq . -

rm queryPayload.json 2>/dev/null
