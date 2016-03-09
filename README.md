LUA / nixio module experimentations
===

Using lua on openwrt OLIMMEX RALINK dev board.
* RT5350F-OLinuXino-EVB
* 32 MB Ram, 32bits cpu ,( MIPS, openWrt linux )
* 25 $ (!) ( 15 $ Soc CPU)
* https://www.olimex.com/Products/OLinuXino/RT5350F/RT5350F-OLinuXino-EVB/open-source-hardware

IO are :
* 2 ethernets port
* wifi acces point
* one GPIO connector and one UEXT connector
* 2 relay 220V 10A
* one press buton


Preinstalled software on the board are :
* **Openwrt**, **busybox**, **ssh** (to be activated by wifi), **lua**
* **lucid** : web server, admin web application, in Lua
* **nixio** : a little framwork for socket communication, process managemant, file/directory access
   [doc](https://neopallium.github.io/nixio/modules/nixio.html)

* noting else...
* no realy docummentations on Lua part!

Here, there are working:
* io.lua : read button, blink relay1. (with files acces on /sys/class )
* socket_client.lua : connect to a host/pot, send data, close
* socket_server.lua : wait connexion on 8080, echo , close client connection

TODO
===

access to all GPIO of the board
direct acces to GIO (without /sys/class/ file management !)

License
===
Free, as libre !
