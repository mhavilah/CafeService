#!/bin/bash
###########################
#
# Query the menu, (ie, available products) at the Cafe Service
#
# Assumes Cafe Server at:  localhost:8888
#
# Usage:  
#      getProducts.sh
#
##########################
CAFE_HOST=localhost
CAFE_PORT=8888
CAFE_BASE_URL=http://$CAFE_HOST:$CAFE_PORT
CAFE_SERVLET_ROOT=$CAFE_BASE_URL
TARGET_URL=$CAFE_SERVLET_ROOT/products

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#
#  Menu/Product Request details...
#
echo =============================
echo Sending: $REQUEST_FILE to the Cafe Service
echo SERVLET_ROOT: $CAFE_SERVLET_ROOT
echo Target URL: $TARGET_URL
curl -X GET --data -H "Content-Type: application/json" -H "Accept: application/json" $TARGET_URL

if [[ $? != 0 ]]
then 
	echo Error: Failed to send to Cafe Serivce Order Endpoint.
	echo Exiting...
	return 1 2>/dev/null || exit 1
fi