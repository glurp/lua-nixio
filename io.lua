#!/usr/bin/lua

local nixio = require("nixio")
local socket = nixio.meta_socket


INPUT = 1
OUTPUT = 0
HIGH = 1
LOW = 0

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


-- ############################## main #################################

print('Button state='..get(0))

k=1
tempo=1000
delta=-50

while get(0)=='0' do
  set(2,k)
  sleep(tempo)
  k=(k+1) % 2
  tempo=tempo+delta
  if tempo<100 or tempo>1000 then
    delta=-delta
  end
end
set(2,1)
print('Button state='..get(0))

-- scp io.lua desktop@ns308363.ovh.net:
