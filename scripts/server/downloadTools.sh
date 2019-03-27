#!/bin/bash

echo Downloading support tools...

echo Checking Operating System....
if [[ `uname -a | grep -i Darwin` == "" ]]
then
	echo Support tools downloader for OSX
	echo On Linux try: apt-get
	echo 'On Windows try: chocolately (https://chocolatey.org/packages/jq)'
	return 1 2>/dev/null || exit 1
else
	echo OSX found OK
fi

echo Checking for brew installer
if [[ `which brew` == "" ]]
then 
	echo Brew installer not resident.
	echo "See:  http://brew.sh"
	return 1 2>/dev/null || exit 1
else
	echo Found brew OK
fi

echo Updating Brew recipes..
brew update

echo Installing jq...
brew install jq

