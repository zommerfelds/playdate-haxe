# Playdate Haxe demo

This is an attempt at building a game for the [Playdate](https://play.date/) using the [Haxe](https://haxe.org/) programming language. This is a work in progress.

# Idea

The approach here is to compile Haxe code into C using the HashLink/C target. Then create a wrapper for calling the Playdate C API from Haxe.

# Building

Download the SDK at https://play.date/dev/
Follow the prerequisites at https://sdk.play.date/2.1.1/Inside%20Playdate%20with%20C.html

For Debian I had to install: `arm-none-eabi-newlib` (not sure about `libc6-dev-armel-cross`).

```
export PLAYDATE_SDK_PATH=~/private/PlaydateSDK-2.1.1
haxelib install hashlink 

haxe --main Main2 -p src --hl out/main.c
make pdc
$PLAYDATE_SDK_PATH/bin/PlaydateSimulator HelloWorld.pdx
```

# Next steps

* Compile hashlink for arm and put instructions here
* Build for actual device
  This QEMU post could be interesting: https://devforum.play.date/t/how-to-emulate-playdate-arm-with-qemu/11538
* Make Haxe call PlayDate API:
  https://github.com/HaxeFoundation/hashlink/wiki/HashLink-native-extension-tutorial
  https://github.com/Aurel300/ammer
* Clean up the repo

# Old notes

The initial approach was to use the C++ target. Then compile it to a library, and use Haxe C Bridge to call that code from a C wrapper. However it wasn't easy to get it working in the Playdate compilation environment and I'm not sure if the threading model works on device.

```
haxelib hxcpp haxe-c-bridge
haxe --main Main -p src --library haxe-c-bridge --cpp bin --dce full -D static_link

#gcc -O3 -o hello -std=c++ -I out out/main.c -lhl [-L/path/to/required/hdll]
```

## Maybe still relevant?

https://github.com/HaxeFoundation/hashlink#building-on-linuxosx

sudo apt-get install libpng-dev libturbojpeg-dev libvorbis-dev libopenal-dev libsdl2-dev libmbedtls-dev libuv1-dev libsqlite3-dev libglu-dev
