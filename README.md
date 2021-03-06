# CafeService
A Demo of using Wiremock API mocks - in a Cafe

### Presentation
<a href="https://mhavilah.github.io/CafeService/index.html" style="font-style:normal;font-weight:bold">
  <img src="docs/Wiremock-APITesting-cover.jpg" width="188" height="125" alt="WireMock API Testing"/>
  <p>WireMock API Testing [PDF]</p>
</a>

## Wiremock Standalone API Example

Wiremock is an API mocking utility written in Java.

It is commonly invoked as an embedded Server within JUnit/TestNG tests.

An alternate mode of usage is to invoke the API mocks as a standalone server.  

This style of usage can be good for:

- demonstration of a server-based application independently of its downstream API service providers
  - an example may be running an application offline 
- testing an application with a proposed or non-existent API implementation
  -	 for example - with a newer API version
- demonstration of a client side application without a corresponding running server	
 
### Configuration 
 
When run as a standalone server, Wiremock uses configuration files to define its behaviour:

- API path mapping rules 
  - (under: %WIREMOCK_HOME%/mappings/)
- Content definitions/files 
  - (under: %WIREMOCK_HOME%/__files/)

where: %WIREMOCK_HOME% is where the wiremock.jar application bundle is installed.

The contents of these files will be explained further below. 


## Wiremock Proxy Example

When run as a proxy in front of an existing API implementation, Wiremock can record request/response interactions.  These recordings can then be "played-back", mocking the actual API service implementation.

### Proxying Request Sequence

![Proxying Sequence](docs/Wiremock-proxying-seq.png?raw=true "Wiremock Proxying")

### WillyWeather API example

The following illustrates the use of the Wiremock Proxy with a cloud based API at WillyWeather (www.willyweather.com.au).

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

**Note:**

API Keys are available at: [https://www.willyweather.com.au/info/api.html]

```
$ ./setAPIKeyEnv.sh 
```

Next, Check the usage of the proxy runner.. 

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

OK - Lets Proxy the Willy Weather API 


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

The following script uses curl to make a HTTP GET request to the Wiremock Server on localhost:9000.

Wiremock then:

- records the request URL in its mappings folder.
- forwards the request on to the Cloud API at WillyWeather
- records the response content returned from the service under __files/
- adds the response file refence in the mappings JSON file.

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

Wiremock will record and save the API requests and the intercepted API responses in the following folders:

- mappings
  - request URL and header meta-data  
- __files
  - request/response body content
  
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
$ ./wiremock.sh 9000
Starting wiremock on port: 9000...
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
2019-04-04 22:04:42.080 Verbose logging enabled
 /$$      /$$ /$$                     /$$      /$$                     /$$      
| $$  /$ | $$|__/                    | $$$    /$$$                    | $$      
| $$ /$$$| $$ /$$  /$$$$$$   /$$$$$$ | $$$$  /$$$$  /$$$$$$   /$$$$$$$| $$   /$$
| $$/$$ $$ $$| $$ /$$__  $$ /$$__  $$| $$ $$/$$ $$ /$$__  $$ /$$_____/| $$  /$$/
| $$$$_  $$$$| $$| $$  \__/| $$$$$$$$| $$  $$$| $$| $$  \ $$| $$      | $$$$$$/ 
| $$$/ \  $$$| $$| $$      | $$_____/| $$\  $ | $$| $$  | $$| $$      | $$_  $$ 
| $$/   \  $$| $$| $$      |  $$$$$$$| $$ \/  | $$|  $$$$$$/|  $$$$$$$| $$ \  $$
|__/     \__/|__/|__/       \_______/|__/     |__/ \______/  \_______/|__/  \__/

port:                         9000
enable-browser-proxying:      false
disable-banner:               false
no-request-journal:           false
verbose:                      false


....
Registered mappings:
....
{
  "mappings": [
    {
      "id": "8d29f4a0-f4fd-3043-82f9-dfa132392887",
      "request": {
        "url": "/locations/2251/weather.json?forecasts=rainfallprobability&days=5&startDate=2017-03-27",
        "method": "GET"
      },
      "response": {
        "status": 200,
        "bodyFileName": "body-2251-weather.json-pPHJl.json",
        "headers": {
          "Date": "Thu, 04 Apr 2019 08:41:38 GMT",
          "Content-Type": "application/json",
          "Transfer-Encoding": "chunked",
          "Connection": "keep-alive",
          "Server": "Apache/2.4.33 (IUS)",
          "X-Powered-By": "PHP/7.0.32",
          "Cache-Control": "no-cache",
          "Vary": "Accept-Encoding,User-Agent"
        }
      },
      "uuid": "8d29f4a0-f4fd-3043-82f9-dfa132392887"
    },
....

```
