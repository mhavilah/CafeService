#!/bin/bash

echo Downloading support tools...

if [[ `uname -a | grep -i Darwin` == "" ]]
then
	echo Support tools downloader for OSX
	echo On Linux try: apt-get
	echo 'On Windows try: chocolately (https://chocolatey.org/packages/jq)'
	return 1 2>/dev/null || exit 1
fi

if [[ `which brew` == "" ]]
then 
	echo Brew installer not resident.
	echo "See:  http://brew.sh"
	return 1 2>/dev/null || exit 1
fi

brew update
brew install jq

