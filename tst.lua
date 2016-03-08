#!/usr/bin/lua

local nixio = require("nixio")


function sleep(n)
  nixio.poll(nil,n)
end

-- main

local so=nixio.bind("0.0.0.0",8080,inet,"stream" )
so:listen(22)

while true do
  print("Waiting or client connexion...")
  local ss=so:accept()

  while true do
    local str= ss:read(30000) 
    if str then
      print(str)
      ss:write("RRRRR:" .. str)
    else
      break
    end
  end
  print("end connexion")
  ss:close()
end
