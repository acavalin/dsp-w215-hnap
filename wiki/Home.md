# D-Link DSP-W215 mydlink Home Smart Plug

### Basic info
The device uses [HNAP](https://en.wikipedia.org/wiki/Home_Network_Administration_Protocol) protocol which is SOAP based protocol.<br>
List of available actions is exposed at address `http://<device ip address>/HNAP1`

### Requests
HNAP action requests must be authenticated and contain these HTTP headers:<br>
* SOAPAction - SOAP action name with full namespace (e.g. `http://purenetworks.com/HNAP1/GetDeviceSettings`)
* HNAP_AUTH - authentication information
* Cookie - authentication cookie

Requests are submitted using HTTP POST method.
Body of the request must be properly formatted. Here is an example of **IsDeviceReady** action:<br>
```
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IsDeviceReady xmlns="http://purenetworks.com/HNAP1/"/>
  </soap:Body>
</soap:Envelope>
```

### Response
Response returned uses the same formatting as request and contains desired information. Here is an example of **IsDeviceReady** action response:
```
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IsDeviceReadyResponse xmlns="http://purenetworks.com/HNAP1/">
      <IsDeviceReadyResult>OK</IsDeviceReadyResult>
    </IsDeviceReadyResponse>
  </soap:Body>
</soap:Envelope>
```