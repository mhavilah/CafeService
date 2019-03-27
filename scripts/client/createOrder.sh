#!/bin/bash
###########################
#
# Create a new order at the Cafe Service
#
# Assumes Cafe Server at:  localhost:8888
#
# Usage:  
#      createOrder.sh [JSON Payload file]
# Eg:
#      createOrder.sh requests/espresso-order.json
#
##########################
CAFE_HOST=localhost
CAFE_PORT=8888
CAFE_BASE_URL=http://$CAFE_HOST:$CAFE_PORT
CAFE_SERVLET_ROOT=$CAFE_BASE_URL
TARGET_URL=$CAFE_SERVLET_ROOT/order

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

usage ()
{
	cat <<EOM
#
# Create a new order at the Cafe Service
#
# Assumes Cafe Server at:  localhost:8888
#
# Usage:
#      createOrder.sh [JSON Payload file]
# Eg:
#      createOrder.sh requests/espresso-order.json
#
EOM
}

if [[ "$1" == "" ]] 
then
	usage
	return 1 2>/dev/null || exit 1
fi

REQUEST_FILE=$DIR/$1

if [[ ! -f $REQUEST_FILE ]]
then
	echo Cannot find request file: $REQUEST_FILE
	return 1 2>/dev/null || exit 1
fi

#
#  Order Request details...
#
echo Order Details:
cat $REQUEST_FILE
echo =============================
echo Sending: $REQUEST_FILE to the Cafe Service
echo SERVLET_ROOT: $SERVLET_ROOT
echo Target URL: $TARGET_URL
curl -X POST --data @$REQUEST_FILE -H "Content-Type: application/json" -H "Accept: application/json" $TARGET_URL

if [[ $? != 0 ]]
then 
	echo Error: Failed to send to Cafe Serivce Order Endpoint.
	echo Exiting...
	return 1 2>/dev/null || exit 1
fi