#!/bin/bash
#################
#
# Get All Journalled Requests from Wiremock 
#
# Queries the Wiremock request history for
# recently received requests.
#
# Usage:
#      ./getAllRequests.sh
# Or
#      ./getAllRequests.sh -v
# For verbose mode
#
# As per:
# http://wiremock.org/docs/verifying/
#
############################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

PORT=8888
BASE_URL=http://localhost:$PORT
URL_PATH=__admin/requests

if [[ $# == 1 && "$1" == "-v" ]]
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
curl -X GET -s -o - $BASE_URL/$URL_PATH | jq . -
