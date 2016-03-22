#!/usr/bin/lua
require('ml').import()

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local str=io.popen('ps'):read("*a") 
local astr=split(str,"\n")
local lpid={}
for i,line in ipairs(astr) do
  local fields=split(" "..line)
  local i1,i2=fields[6]:find(arg[1])
  if i1  then
       lpid[fields[6]] = tonumber(fields[2]) 
  end
end
-- print(tstring(lpid))
for name,pid in pairs(lpid) do
  local fn="/proc/"..pid.."/stat"
  if file_exists(fn) then
    local fs = split(readfile(fn))
    --print(tstring(fs))
    print( string.format("%-30s ==> %5d KB",name,tonumber(fs[23])/1024 -1300 +32   ) )
  end
end
