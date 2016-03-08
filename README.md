LUA / nixio module experimentations
============================

Using lua on openwrt OLIMMEX RALINK dev board.

Preinstalled on the board, there are :
* lua
* lucid : web server, admin web application
* nixio : a little framwork for socket communication, process managemant, file/directory access
* noting else...

Here there are working:
* io.lua : read button, blink relay1. (with files ascces on /sys/class )
* soclet_cleint.lua : connect to a host/pot, sened data, close
* socket_server.lua : wait connexion on 8080, echo , close client connextion

ToDO
===

access to all GPIO of the board
direct acces to GIO (without /sys/class/ file management !)

License
===
Free as libre !
