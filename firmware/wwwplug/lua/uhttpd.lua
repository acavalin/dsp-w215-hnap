-- Copyright 2010 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.
require 'nixio.util'

function handle_request(env)
  exectime = os.clock()
  renv = {
    CONTENT_LENGTH  = env.CONTENT_LENGTH,
    CONTENT_TYPE    = env.CONTENT_TYPE,
    REQUEST_METHOD  = env.REQUEST_METHOD,
    REQUEST_URI     = env.REQUEST_URI,
    PATH_INFO       = env.PATH_INFO,
    SCRIPT_NAME     = env.SCRIPT_NAME:gsub("/+$", ""),
    SCRIPT_FILENAME = env.SCRIPT_NAME,
    SERVER_PROTOCOL = env.SERVER_PROTOCOL,
    QUERY_STRING    = env.QUERY_STRING,
    DOCUMENT_ROOT   = env.DOCUMENT_ROOT,
    HTTPS           = env.HTTPS,
    REDIRECT_STATUS = env.REDIRECT_STATUS,
    REMOTE_ADDR     = env.REMOTE_ADDR,
    REMOTE_NAME     = env.REMOTE_NAME,
    REMOTE_PORT     = env.REMOTE_PORT,
    REMOTE_USER     = env.REMOTE_USER,
    SERVER_ADDR     = env.SERVER_ADDR,
    SERVER_NAME     = env.SERVER_NAME,
    SERVER_PORT     = env.SERVER_PORT
  }

  local k, v
  for k, v in pairs(env.headers) do
    k = k:upper():gsub("%-", "_")
    renv["HTTP_" .. k] = v
  end

  getcommand = string.sub(renv["REQUEST_URI"],15,65)

  if     getcommand == 'on' then
    os.execute('echo 1   > /sys/class/gpio/gpio:ac_output_enable/value'           )
    os.execute('echo 255 > /sys/devices/platform/leds/leds/green:power/brightness')
    --os.execute('echo 0   > /sys/devices/platform/leds/leds/red:power/brightness'  )
    os.execute('echo 255 > /sys/devices/platform/leds/leds/green:wps/brightness')
    --os.execute('echo 0   > /sys/devices/platform/leds/leds/red:wps/brightness'  )
  elseif getcommand == 'off' then
    os.execute('echo 0   > /sys/class/gpio/gpio:ac_output_enable/value'           )
    os.execute('echo 0   > /sys/devices/platform/leds/leds/green:power/brightness')
    --os.execute('echo 255 > /sys/devices/platform/leds/leds/red:power/brightness'  )
    os.execute('echo 0   > /sys/devices/platform/leds/leds/green:wps/brightness')
    --os.execute('echo 255 > /sys/devices/platform/leds/leds/red:wps/brightness'  )
  end

  local file = io.open('/sys/class/gpio/gpio:ac_output_enable/value', 'r')
  powerstat  = string.sub(file:read '*a', 1, 1)
  file:close()
  print("Content-type: Text/html\n\r")
  if getcommand == 'state' then
    if powerstat == '1' then
      print('true')
    else
      print('false')
    end
  else
    print('<head><title>DSP-W215</title><link rel="icon" type="image/png" href="/favicon-power-' .. powerstat .. '.png" /></head>')
    print('<body>')
    if powerstat == '1' then
      print('<div id="powerstatus">Power is on</div>')
      powercolor  = '0 180 0'
      powershadow = '0 180 0'
      nextclick   = renv['SCRIPT_NAME'] .. '/off'
    else
      print('<div id="powerstatus">Power is off</div>')
      powercolor  = '180 0 0'
      powershadow = '180 0 0'
      nextclick   = renv['SCRIPT_NAME'] .. '/on'
    end
    print('<style type="text/css">div{width:100%;position:absolute;text-align:center;left:0px;font-family:sans-serif;}div#powerstatus{top:calc(50vh + 90px);}div#lucilink{bottom:0px;}div#lucilink a{color:lightgray;text-decoration:none;}svg{position: absolute;top:calc(50vh - 120px);left:calc(50vw - 100px);width:200px;height:200px;filter:drop-shadow(0px 0px 7px rgb(' .. powershadow .. ' / 0.6));}svg:hover{filter:drop-shadow(0px 0px 8px rgb(' .. powershadow .. ' / 0.8));}</style>')
    print('<a href="' .. nextclick .. '">')
    print('<svg width="800px" height="800px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M10 8.08223C10 7.89949 9.81059 7.7796 9.65181 7.87007C8.21726 8.68749 7.25 10.2308 7.25 12C7.25 14.6234 9.37665 16.75 12 16.75C14.6234 16.75 16.75 14.6234 16.75 12C16.75 10.2308 15.7827 8.68749 14.3482 7.87007C14.1894 7.7796 14 7.89948 14 8.08223V9.31619C14 9.39312 14.0358 9.46532 14.0946 9.51493C14.8012 10.1111 15.25 11.0031 15.25 12C15.25 13.7949 13.7949 15.25 12 15.25C10.2051 15.25 8.75 13.7949 8.75 12C8.75 11.0031 9.19881 10.1111 9.90539 9.51493C9.96419 9.46532 10 9.39312 10 9.31619V8.08223Z" fill="rgb(' .. powercolor .. ')"/><path d="M12.75 7C12.75 6.58579 12.4142 6.25 12 6.25C11.5858 6.25 11.25 6.58579 11.25 7V12C11.25 12.4142 11.5858 12.75 12 12.75C12.4142 12.75 12.75 12.4142 12.75 12V7Z" fill="rgb(' .. powercolor .. ')"/><path fill-rule="evenodd" clip-rule="evenodd" d="M3.25 12C3.25 7.16751 7.16751 3.25 12 3.25C16.8325 3.25 20.75 7.16751 20.75 12C20.75 16.8325 16.8325 20.75 12 20.75C7.16751 20.75 3.25 16.8325 3.25 12ZM12 4.75C7.99594 4.75 4.75 7.99594 4.75 12C4.75 16.0041 7.99594 19.25 12 19.25C16.0041 19.25 19.25 16.0041 19.25 12C19.25 7.99594 16.0041 4.75 12 4.75Z" fill="#FFFFFF"/></svg>')
    print('</a>')
    print('<div id="lucilink"><a href="http://' .. renv["SERVER_ADDR"] .. '/">LuCI</a></div>')
    print('</body>')
  end
end
