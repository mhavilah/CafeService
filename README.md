# CafeService
A Demo of using Wiremock API mocks - in a Cafe

## Wiremock Standalone API Example

TODO TODO

## Wiremock Proxy Example

The following illustrates the use of the Wiremock Proxy with a cloud based API
at WillyWeather (www.willyweather.com.au).

Some helper scripts have been provided to:
- setup the API Key in the local environment
- start the Wiremock Proxy for the target API
- run a simple weather API request to the service

#### Prerequisites

These scripts were written on OSX but should run in any bash environment.

The following tools are required:
- curl
- jq [https://stedolan.github.io/jq/download/]
- Wiremock (included)

On Mac OSX, the former two tools can be easily installed via **brew** [http://brew.sh]
```
brew install jq 
```

On Linux, apt-get installer or yum package manager are your best bet:
```
sudo apt-get install jq
```

For Windows, Chocolately installer is recommended (https://chocolatey.org/).
```
choco install jq
```


### Sample Proxy Session

First, for convenience, setup the API Key in the local environment
```
$ ./setAPIKeyEnv.sh 
```

Next, Check the usage of the proxy runner.. Check the usage of the proxy runner..

```
$ ./startProxy.sh 
###########################
#
# startProxy.sh
#
# Start a Wiremock recording proxy server
# Records requests to an API and builds
# stub mappings and records response files.
#
# Usage:
#   startProxy.sh [proxyPortNumber] [targetAPI] [key] 
#
# Where:
#   proxyPortNumber is the TCP/IP port at localhost of the Wiremock proxy
#   targetAPI is the remote service to be proxied.
#   key (optional) is an API key that is required for access
#
# Note:
#   If the API key is omitted, an unauthenticated API is assumed.
#   If the API Key is provided, it will be appended to the targetAPI
#    as a path parameter
#
# Examples:
#  ./startProxy.sh 9000 https://api.willyweather.com.au/v2 
#     Proxies requests to http://localhost:9000 onto the above URL.
# 
#  ./startProxy.sh 9000 https://api.willyweather.com.au/v2 =Aer3423n?
#     Proxies requests to http://localhost:9000 onto the 
#     API authenticated base URL:  https://api.willyweather.com.au/v2/=Aer3423n?
#
############################
```

OK - Lets Proxy the Wily Weather API

```
$ ./startProxy.sh 9000 https://api.willyweather.com.au/v2 &
Checking API_KEY env var for API Key...
Found API_KEY environment variable.
Using authenticated API...
Starting Wiremock proxy.
Listening on port: 9000
Proxying API Service: https://api.willyweather.com.au/v2/<<API KEY>>
API Mappings will be saved under:
/Users/mhavilah/projects/api/weather/mappings
API Responses will be saved under:
/Users/mhavilah/projects/api/weather/__files
=============================================
Requests to: http://localhost:9000 will be forwarded to: https://api.willyweather.com.au/v2/<<API KEY>>
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
 /$$      /$$ /$$                     /$$      /$$                     /$$      
| $$  /$ | $$|__/                    | $$$    /$$$                    | $$      
| $$ /$$$| $$ /$$  /$$$$$$   /$$$$$$ | $$$$  /$$$$  /$$$$$$   /$$$$$$$| $$   /$$
| $$/$$ $$ $$| $$ /$$__  $$ /$$__  $$| $$ $$/$$ $$ /$$__  $$ /$$_____/| $$  /$$/
| $$$$_  $$$$| $$| $$  \__/| $$$$$$$$| $$  $$$| $$| $$  \ $$| $$      | $$$$$$/ 
| $$$/ \  $$$| $$| $$      | $$_____/| $$\  $ | $$| $$  | $$| $$      | $$_  $$ 
| $$/   \  $$| $$| $$      |  $$$$$$$| $$ \/  | $$|  $$$$$$/|  $$$$$$$| $$ \  $$
|__/     \__/|__/|__/       \_______/|__/     |__/ \______/  \_______/|__/  \__/

port:                         9000
proxy-all:                    https://api.willyweather.com.au/v2/<<API KEY>>
preserve-host-header:         false
enable-browser-proxying:      false
disable-banner:               false
record-mappings:              true
match-headers:                []
no-request-journal:           false
verbose:                      false
```

And finally, get a weather forecast...

```
$ ./getProxiedRain.sh 
Getting weather for: 2019-04-04 at Queenscliff
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2601    0  2601    0     0  29375      0 --:--:-- --:--:-- --:--:-- 29556
{
  "location": {
    "id": 2251,
    "name": "Queenscliff",
    "region": "Sydney",
    "state": "NSW",
    "postcode": "2096",
    "timeZone": "Australia/Sydney",
    "lat": -33.7846,
    "lng": 151.28782,
    "typeId": 1
  },
  "forecasts": {
    "rainfallprobability": {
      "days": [
        {
          "dateTime": "2019-04-04 00:00:00",
          "entries": [
            {
              "dateTime": "2019-04-04 02:00:00",
              "probability": 5
........
$
```

#### Mapping/Content Files

Wiremock will save the API requests and the intercepted API responses in the following folders:

- mappings
- __files

```
$ ls -l mappings
total 16
-rw-r--r--  1 user staff  692  4 Apr 19:41 mapping-2251-weather.json-pPHJl.json
-rw-r--r--  1 user staff  692  4 Apr 19:43 mapping-2251-weather.json-tllud.json
$ 
$ 
$ ls -l __files
total 24
-rw-r--r--  1 user staff   316  4 Apr 16:46 body-2251-weather.json-bELVn.json
-rw-r--r--  1 user staff   316  4 Apr 19:41 body-2251-weather.json-pPHJl.json
-rw-r--r--  1 user staff  2601  4 Apr 19:43 body-2251-weather.json-tllud.json
```

If the Wiremock Server is re-started without the proxying switches, it will serve those content files to new API requests:

```
$ ./wiremock.sh

```
