#!/usr/bin/lua

local nixio = require("nixio")


function sleep(n)
  nixio.poll(nil,n)
end

-- main

--                     Only with dns name !!!!
local so=nixio.connect("ns308363.ovh.net",80,"inet","stream" )
print("Peername :".. so:getpeername())

so:write("GET / HTTP/1.0\r\n\r\n")
print( so:read(300) )
so:close()
