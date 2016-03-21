#!/usr/bin/lua
--------------------------------------------------------------
--
-- ioso.lua  serveur TCP pour commandes Relay1/Relay2 (par Andoid?")
--
--------------------------------------------------------------

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

-- nixio doc : https://neopallium.github.io/nixio/modules/nixio.html

function sleep(ms)
 nixio.poll(nil,ms)
end

function microsleep(micro)
  nixio.nanosleep(0,micro*1000)
end

-- scp io.lua desktop@ns308363.ovh.net:

-- W<nio/<value>CRLF
-- RCRLF
function doAction(str)
 print(str,str:len())
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
 print("  "..ret)
 return ret
end

-- main

print("Set serveur TCP on port 9900...")
local so=nixio.bind("0.0.0.0",9900,inet,"stream" )
so:listen(22)

while true do
  print(" Waiting or client connexion...")
  local ss=so:accept()
  print("  connected")
  repeat
    local str= ss:read(30000) 
    if str and str:len()>0 then
      print("  Received : ",str);
      rep=doAction(str)
      ss:write(rep)
    end
  until str:len()==0
  print("end connexion")
  ss:close()
end
