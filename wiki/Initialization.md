# Initialization

In order to connect the plug into your wifi you must do following:<br>
* retrieve RadioID
* obtain WLAN information (you can use build-in survey of available WLANs)
* set up AP client

### Retrieve RadioID
Submit request for action `GetWLanRadios`
```
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetWLanRadios xmlns="http://purenetworks.com/HNAP1/"/>
  </soap:Body>
</soap:Envelope>
```

In the response you get `<RadioID>RADIO_2.4GHz</RadioID>` which you use for subsequent requests.

### Run survey of wireless networks
Submit request for action `SetTriggerWirelessSiteSurvey` and include `RadioID` retrieved from previous step.
```
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SetTriggerWirelessSiteSurvey xmlns="http://purenetworks.com/HNAP1/">
      <RadioID>RADIO_2.4GHz</RadioID>
    </SetTriggerWirelessSiteSurvey>
  </soap:Body>
</soap:Envelope>
```

In the response element `WaitTime` there is an information when the survey will be completed

```
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SetTriggerWirelessSiteSurveyResponse xmlns="http://purenetworks.com/HNAP1/">
      <SetTriggerWirelessSiteSurveyResult>OK</SetTriggerWirelessSiteSurveyResult>
      <WaitTime>8</WaitTime>
    </SetTriggerWirelessSiteSurveyResponse>
  </soap:Body>
</soap:Envelope>
```

After the period submit request for action `GetSiteSurvey`
```
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetSiteSurvey xmlns="http://purenetworks.com/HNAP1/">
      <RadioID>RADIO_2.4GHz</RadioID>
    </GetSiteSurvey>
  </soap:Body>
</soap:Envelope>
```

In the response you receive list of discovered wireless networks with all necessary details for the final step:
```
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetSiteSurveyResponse xmlns="http://purenetworks.com/HNAP1/">
      <GetSiteSurveyResult>OK</GetSiteSurveyResult>
      <APStatInfoLists>
        <APStatInfo>
          <SSID>My_Network</SSID>
          <MacAddress>XX:XX:XX:XX:XX:XX</MacAddress>
          <SupportedSecurity>
            <SecurityInfo>
              <SecurityType>WPA2-PSK</SecurityType>
              <Encryptions>
                <string>AES</string>
              </Encryptions>
            </SecurityInfo>
          </SupportedSecurity>
          <Channel>3</Channel>
          <SignalStrength>82</SignalStrength>
        </APStatInfo>
      </APStatInfoLists>
    </GetSiteSurveyResponse>
  </soap:Body>
</soap:Envelope>
```

### Set up AP client
Submit final request for action `SetAPClientSettings` and put the proper wireless network information.<br>
The element `Key` contains encrypted password for you wireless network.
```
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <SetAPClientSettings xmlns="http://purenetworks.com/HNAP1/">
      <Enabled>true</Enabled>
      <RadioID>RADIO_2.4GHz</RadioID>
      <SSID>My_Network</SSID>
      <MacAddress>XX:XX:XX:XX:XX:XX</MacAddress>
      <ChannelWidth>0</ChannelWidth>
      <SupportedSecurity>
        <SecurityInfo>
          <SecurityType>WPA2-PSK</SecurityType>
          <Encryptions>
            <string>AES</string>
          </Encryptions>
        </SecurityInfo>
      </SupportedSecurity>
      <Key>.........</Key>
    </SetAPClientSettings>
  </soap:Body>
</soap:Envelope>
```