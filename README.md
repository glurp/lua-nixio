LUA / nixio module experimentations
============================

Using lua on openwrt OLIMMEX RALINK dev board.
* RT5350F-OLinuXino-EVB
* https://www.olimex.com/Products/OLinuXino/RT5350F/RT5350F-OLinuXino-EVB/open-source-hardware
* 25 $ (!)
* 32 MB Ram, 32bits cpu ,( MIPS, openWrt linux )

IO are :
* 2 relay 220V 10A
* one press buton
* 2 ethernets port
* wifi acces point
* one GPIO connector and one UEXT connector


Preinstalled software on the board are :
* lua
* lucid : web server, admin web application, in Lua
* nixio : a little framwork for socket communication, process managemant, file/directory access
* noting else...
* no docummantations !

Here, there are working:
* io.lua : read button, blink relay1. (with files acces on /sys/class )
* soclet_client.lua : connect to a host/pot, send data, close
* socket_server.lua : wait connexion on 8080, echo , close client connection

ToDO
===

access to all GPIO of the board
direct acces to GIO (without /sys/class/ file management !)

License
===
Free, as libre !
