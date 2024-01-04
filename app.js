// Tool for reading data from D-Link DSP-W215 Home Smart Plug.

// configurazione wifi presa via WPS:
//   1. router > wireless > wlan2 > Advanced mode > set "WPS mode" = "push button"
//   2. router > wireless > wlan2 > *WPS accept* button
//   3. presa > premi pulsante WPS
//
// npm install
// makeself --nocrc --nomd5 --tar-quietly --xz . ~/bin/dsp-w215.run dsp-w215-hnap run.sh
var DEVICE_IP  = process.argv[2];
var DEVICE_PIN = process.argv[3];
var METHOD     = process.argv[4];
var METHODS    = ['on', 'off', 'state', 'reboot', 'temperature', 'consumption', 'totalConsumption'];

if (process.argv.length != 5 || !METHODS.includes(METHOD)) {
  console.log(`USAGE: node app.js IP PIN <${METHODS.join('|')}>`);
  process.exit();
}//if

var soapclient = require('./js/soapclient');

soapclient.
  login('admin', DEVICE_PIN, `http://${DEVICE_IP}/HNAP1`).
  done(function (status) {
    if (!status || status != "success")
      throw "Login failed!";
    
    soapclient[METHOD]().
      done(function (result) {
        console.log(result);
      });
  });
