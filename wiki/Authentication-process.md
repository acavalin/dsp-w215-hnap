# Authentication process

In order to perform authentication two requests must be performed.

## Step one
Send login request and wait for returned values of `Challenge`, `Cookie` and `PublicKey` elements that are necessary for building the second authentication request.

### Request
```
Headers:
"Content-Type": "text/xml; charset=utf-8"
"SOAPAction": "http://purenetworks.com/HNAP1/Login"

<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Login xmlns="http://purenetworks.com/HNAP1/">
      <Action>request</Action>
      <Username>admin</Username>
      <LoginPassword/>
      <Captcha/>
    </Login>
  </soap:Body>
</soap:Envelope>
```
### Response
```
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <LoginResponse xmlns="http://purenetworks.com/HNAP1/">
      <LoginResult>OK</LoginResult>
      <Challenge>........</Challenge>
      <Cookie>........</Cookie>
      <PublicKey>........</PublicKey>
    </LoginResponse>
  </soap:Body>
</soap:Envelope>
```

### Step two
Now we build the second request using values retrieved in previous response.<br>
Value of `Cookie` will be used for HTTP header `Cookie`<br>
Values `Challenge` and `PublicKey` will be used for encryption of login password. The encrypted password will be used for HTTP header `HNAP_AUTH`

### Request
```
Headers:
"Content-Type": "text/xml; charset=utf-8"
"SOAPAction": "http://purenetworks.com/HNAP1/Login"
"HNAP_AUTH": "........"
"Cookie": "uid=........"

<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Login xmlns="http://purenetworks.com/HNAP1/">
      <Action>login</Action>
      <Username>admin</Username>
      <LoginPassword>........</LoginPassword>
      <Captcha/>
    </Login>
  </soap:Body>
</soap:Envelope>
```

### Response
```
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <LoginResponse xmlns="http://purenetworks.com/HNAP1/">
      <LoginResult>success</LoginResult>
    </LoginResponse>
  </soap:Body>
</soap:Envelope>
```