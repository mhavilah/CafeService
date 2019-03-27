#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

$DIR/getAllRequests.sh  | jq .requests[0].response.body | sed 's/\\\"/"/g' | sed 's/^\"\(.*\)\"/\1/g'| sed 's/\\n//g' | jq .
