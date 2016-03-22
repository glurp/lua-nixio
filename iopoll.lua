#!/usr/bin/lua
--------------------------------------------------------------
--
-- iopoll.lua  TCPi server  pour acces to  Relay1/Relay2
--           Async server :  nixio.poll() is use for 
--           manage multi-socket connexion/server 
--
--------------------------------------------------------------

-- nixio doc : https://neopallium.github.io/nixio/modules/nixio.html

local nixio = require("nixio")

----- Check if a file exists
function file_exists(filename)
   local file=io.open(filename,"r")
   if file~=nil then io.close(file) return true else return false end
end


----- Overwites existing file or creates a new file
function writeToFile (filename, data)
	local file=io.open(filename, 'w')
	file:write(data)
	file:close()	
end


----- Reads one byte data from file & returns the string
function readFromFile (filename)
	if file_exists(filename) then
		local file=io.open(filename, 'r')
		local data = file:read(1)
		file:close()
		return data	
	else
		return ""
	end
	
end

function set(pin,value)
	local file='/sys/class/gpio/relay'..pin..'/value'
        writeToFile(file,''..value);
end

function get(pin)
	if pin > 0 then
		local file='/sys/class/gpio/relay'..pin..'/value'
        	return readFromFile(file)
	else
		local file='/sys/class/gpio/button/value'
        	return readFromFile(file)
	end
end


function sleep(ms)
 nixio.poll(nil,ms)
end

function microsleep(micro)
  nixio.nanosleep(0,micro*1000)
end



-- ************************* Events ****************************
-- a stupid event loop : event managed are only TCP/read/error 
-- defined by 3 requests : register(socket), unregister(socket) , mainloop()
-- inspiration: https://github.com/xopxe/lumen
--               selector-nixio.lua

gsockets={} -- table of sockets currently selectable

function mainloop(timeout) 
 while true do
   local stat = nixio.poll(gsockets,timeout)
   if  stat==false  then
     timer()
   else
    for i,f  in ipairs(gsockets) do
      local revents = f.revents 
      if revents and revents ~= 0 then
        local mode = nixio.poll_flags(revents)
        f.handler(f.fd,mode)
      end
    end
   end
  end
end

function register(so,sohandler)
  for k, v in ipairs(gsockets) do
    if socket==v.fd then
      print("register already done!")
      return
    end
  end
  local dscr= { fd=so , events=nixio.poll_flags("in", "pri") ,handler=sohandler}
  gsockets[#gsockets+1]=dscr 
  print("register done")
end

function unregister(socket) 
  for k, v in ipairs(gsockets) do
    if socket==v.fd then
      table.remove(gsockets,k)
      v.fd:close()
      print("unregister done")
      return
    end
  end
  print("unregister(): socket not finded!")
end

-----------------------  Application callbacks

function timer()
 -- print("timeout...")
end

function doAction(str)
 if str:len()>3 and str:len()<=6 then
   local commande=string.sub(str,1,1)
   local eqp=tonumber(string.sub(str,2,2))
   local sep=string.sub(str,3,3)
   local value=tonumber(string.sub(str,4,4))
   if commande=="W" and (eqp==1 or eqp==2) and (value ==1 or value ==0) then 
     set(eqp,value)
   else
    print("  error syntaxe !")
   end
 end
 local ret="R"..get(1).."/"..get(2).."\r\n"
 return ret
end

function client_event(so,event)
  local str= so:read(30000) 
  if str and str:len()>0 then
    rep=doAction(str)
    so:write(rep)
  end
  if str==nil or str:len()==0 then
    unregister(so)
  end
end

-- ===================== M a i n ===============================

local so=nixio.bind("0.0.0.0",9900,inet,"stream" )
so:listen(22)

register(so,function(s,event)
  if s then
    local ss,host,port=s:accept()
    register(ss,client_event)
  else
    print("error reading listen socket for connexion..")
  end
end)

print("entered in mainloop()...")

mainloop(1000)

