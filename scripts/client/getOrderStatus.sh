#!/bin/bash
###########################
#
# Query the order status at the Cafe Service
#
# Assumes Cafe Server at:  localhost:8888
#
# Usage:  
#      getOrderStatus.sh [orderID]
#
##########################
CAFE_HOST=localhost
CAFE_PORT=8888
CAFE_BASE_URL=http://$CAFE_HOST:$CAFE_PORT
CAFE_SERVLET_ROOT=$CAFE_BASE_URL
TARGET_URL=$CAFE_SERVLET_ROOT/order/$1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

usage ()
{
cat <<EOM
###########################
#
# Query the order status at the Cafe Service
#
# Assumes Cafe Server at:  localhost:8888
#
# Usage:
#      getOrderStatus.sh [orderID]
#
##########################
EOM
}

if [[ "$1" == "" ]]
then
    usage
    return 1 2>/dev/null || exit 1
fi

#
#  Menu/Product Request details...
#
echo =============================
echo Sending: $REQUEST_FILE to the Cafe Service
echo SERVLET_ROOT: $CAFE_SERVLET_ROOT
echo Target URL: $TARGET_URL

RESPONSE=$(curl -X GET -s -o - -H "Content-Type: application/json" -H "Accept: application/json" $TARGET_URL)

if [[ $? != 0 ]]
then 
	echo Error: Failed to send to Cafe Serivce Order Endpoint.
	echo Exiting...
	return 1 2>/dev/null || exit 1
else
    echo $RESPONSE | jq .
fi