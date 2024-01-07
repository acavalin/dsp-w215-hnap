# DSP-W215 Revision B2: flash original firmware

See: D-Link [drivers archive](https://ftp.dlink.de/dsp/dsp-w215/archive/driver_software/).

1. Remove DSP-W215 from power socket.
1. Press and hold the reset button on the side of the DSP-W215 and plug it into
   power socket.
1. Continue holding the WPS/reset button until the LED is flashing red.
1. Connect to Wi-Fi network broadcasted by the DSP-W215 (the network name should
   start with DSP-xxxx)
1. Open a Web Browser and go to http://192.168.0.60
1. Upgrade the firmware by uploading the file `DSP-W215B2_FW224B01.bin`

# DSP-W215 Revision B1: flash OpenWRT firmware

This app doesn't fully work with the B1 revision (can't toggle power), but we
can install a [custom OpenWRT firmware](https://openwrt.org/toh/d-link/dsp-w215)
and then use SSH commands altough the main power button will not work anymore.

See: OpenWRT [dsp-w215 page](https://openwrt.org/toh/d-link/dsp-w215) and
[forum with custom firmware](https://forum.openwrt.org/t/d-link-dsp-w215-smart-plug-openwrt-support/129502),
Magnus Wedberg's [blog post](https://www.magnuswedberg.com/index.php?doc=OpenWRT_on_a_D-Link_DSP-W215).

1. Press and hold the reset button on the side of the DSP-W215 and plug it into
   power socket.
1. Connect to the unsecured DSP-W215B-xxxx WiFi network now broadcasted,
   and visit the web UI at http://192.168.0.60
1. Flash the `openwrt-ath79-tiny-dlink_dsp-w215-b1-squashfs-factory.bin` firmware
1. Wait until the unit has rebooted
1. Connect to the new OpenWRT-initiated DSP-xxxx network now broadcasted,
   the password is SSID + 6-digit PIN code (eg. DSP-xxxx123456)
1. Visit the web UI at http://192.168.1.1, the default pass is blank, you can change
   it at System > Administration
1. Upgrade OpenWRT at System > Backup > Flash Firmware with the
   `openwrt-ath79-tiny-dlink_dsp-w215-b1-squashfs-sysupgrade_400mhz.bin` firmware
1. Wait until the unit has rebooted
1. Reconnect to WiFi (same as step 5)
1. Connect to your client WiFi:
   - Go to Network > Wireless
   - On the *Radio* line, click *Scan*
   - Join your WiFi network
   - Check *Replace wireless configuration*
   - Fill in your WiFi passphrase
   - Bind the firewall zone to *wan* (pre-filled, don't touch this)!
   - At the next screen with advanced settings, don't change anything. Do NOT change the WiFi channel!
   - Save your settings **but don't apply them**
1. Go to Network > Firewall. Open up the WAN by allowing everything
   (Zones > wan: accept-accept-accept). Save **but do not apply**.
1. Click the arrow to the right of *Save and apply* and choose *Apply unchecked*
   (IMPORTANT -- otherwise the device will reset the settings!).
   Then click the big red button to apply.
1. The device should now be visible on your main network. Check your DHCP server
   (for example, the client list in your router) for which local IP it got.
   You can of course also use a fixed IP.
1. If it's not visible after a few minutes you can always start over from 1 again.

Now you can toggle power and the two leds with SSH commands:

~~~shell
# power ON/OFF
ssh root@192.168.x.y 'echo 1 > /sys/class/gpio/gpio:ac_output_enable/value'
ssh root@192.168.x.y 'echo 0 > /sys/class/gpio/gpio:ac_output_enable/value'

# <ON/OFF> <green|red> led of <power|wps> button 
ssh root@192.168.x.y 'echo <255|0> > /sys/devices/platform/leds/leds/<green|red>:<power|wps>/brightness'
~~~

## WebUI with GETable urls

Following Magnus Wedberg's [instructions](https://www.magnuswedberg.com/index.php?doc=OpenWRT_on_a_D-Link_DSP-W215)
we are going to put a web interface on port 3000.

1. Visit and login into the web UI at http://192.168.1.1

1. Turn off plug at startup: System > Startup > Local startup, add these commands before `exit 0`:
   
   ~~~shell
   echo 0   > /sys/class/gpio/gpio:ac_output_enable/value
   
   ( sleep 20 ; echo 0   > /sys/devices/platform/leds/leds/green:power/brightness )
   #( sleep 20 ; echo 255 > /sys/devices/platform/leds/leds/red:power/brightness )
   
   ( sleep 20 ; echo 0   > /sys/devices/platform/leds/leds/green:wps/brightness )
   #( sleep 20 ; echo 255 > /sys/devices/platform/leds/leds/red:wps/brightness )
   ~~~

1. System > Software > Update lists, then install `uhttpd-mod-lua` package

1. Connect via ssh then edit `uhttpd` config:
   
   ~~~shell
   ssh root@192.168.x.y
   vi /etc/config/uhttpd
   ~~~
   
1. insert this section after the *main* one:
   
   ~~~
   config uhttpd 'plug'  
           list listen_http '0.0.0.0:3000'
           list listen_http '[::]:3000'
           option home '/wwwplug/html'
           option rfc1918_filter '0'
           option max_requests '3'
           option max_connections '100'
           option cgi_prefix '/cgi-bin'
           list lua_prefix '/cgi-bin/plug=/wwwplug/lua/uhttpd.lua'
           option script_timeout '60'
           option network_timeout '30'
           option http_keepalive '20'
           option tcp_keepalive '1'
   ~~~
   
1. copy local `wwwplug` folder to `/`:
  
  ~~~shell
  scp -O -r wwwplug root@192.168.x.y:/
  ~~~
  
1. System > Reboot > Perform reboot

1. Now you can control the plug via web by visiting http://192.168.x.y:3000/
   and via curl/wget:
   
   ~~~shell
   curl http://192.168.x.y:3000/cgi-bin/plug/on   # turn ON
   curl http://192.168.x.y:3000/cgi-bin/plug/off  # turn OFF
   ~~~
