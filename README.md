# Playdate Haxe demo

This is an attempt at building a game for the [Playdate](https://play.date/) using the [Haxe](https://haxe.org/) programming language. This is a work in progress.

# Idea

The approach here is to compile Haxe code into C using the HashLink/C target. Then create a wrapper for calling the Playdate C API from Haxe.

# Building

Download the SDK at https://play.date/dev/
Follow the prerequisites at https://sdk.play.date/2.1.1/Inside%20Playdate%20with%20C.html

For Debian I had to install: `arm-none-eabi-newlib` (not sure about `libc6-dev-armel-cross`).

Download Hashlink from https://github.com/HaxeFoundation/hashlink/releases. Unpack it and run `make`.

```
haxelib install hashlink
cd path_to_haxelib
cmake .
make
```

Make sure the path is set up correctly in the Makefile. TODO: include hashlink in the repo?

TODO: this doesn't seem to compile with the latest versions

```
export PLAYDATE_SDK_PATH=~/private/PlaydateSDK-2.6.2

haxe --main Main2 -p src --hl out/main.c
make pdc
$PLAYDATE_SDK_PATH/bin/PlaydateSimulator HelloWorld.pdx
```

# Codespaces notes
```
# TODO: change the notes here to download files outside of the git root

sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install -y haxe
mkdir ~/haxelib && haxelib setup ~/haxelib
haxelib install hashlink

sudo apt-get install -y libpng-dev libturbojpeg-dev libvorbis-dev libopenal-dev libsdl2-dev libglu1-mesa-dev libmbedtls-dev libuv1-dev libsqlite3-dev
HASHLINK_VERSION=1.14
mkdir /workspaces/build
cd /workspaces/build
wget https://github.com/HaxeFoundation/hashlink/archive/refs/tags/$HASHLINK_VERSION.tar.gz -O /tmp/hashlink.tar.gz
tar -xvzf /tmp/hashlink.tar.gz
cd hashlink-$HASHLINK_VERSION

echo -e '\nlibhl_static: ${LIB}\n\tar rcs libhl.a ${LIB}' >> Makefile
sed -i '/#define HL_H/a #define char16_t uint16_t' src/hl.h

make libhl_static

cd ..
sudo apt-get install -y gcc-arm-none-eabi gcc-multilib
PLAYDATE_SDK_VERSION=2.6.2
wget https://download-cdn.panic.com/playdate_sdk/Linux/PlaydateSDK-$PLAYDATE_SDK_VERSION.tar.gz -O /tmp/playdate-sdk.tar.gz
tar -xvzf /tmp/playdate-sdk.tar.gz
export PLAYDATE_SDK_PATH=$(pwd)/PlaydateSDK-$PLAYDATE_SDK_VERSION

haxe --main Main2 -p src --hl out/main.c
make simulator
$PLAYDATE_SDK_PATH/bin/PlaydateSimulator HelloWorld.pdx
```

Building for the device

tmp notes:
```
libhl_static_device: ${LIB}
	arm-none-eabi-ar rcs libhl.a ${LIB}

nope: # sudo apt-get install -y libc6-dev-armhf-cross

CFLAGS += -fPIC -fno-omit-frame-pointer

make CC=arm-none-eabi-gcc AR=arm-none-eabi-ar libhl_static

#   24  (cd tmp; rm *; arm-none-eabi-ar -x ../libhl.a; file array.o)
```

```
cd hashlink-$HASHLINK_VERSION
make CC=arm-none-eabi-gcc AR=arm-none-eabi-ar libhl_static
make device
```

# Next steps

- Compile hashlink for arm and put instructions here
- Build for actual device
  This QEMU post could be interesting: https://devforum.play.date/t/how-to-emulate-playdate-arm-with-qemu/11538
- Make Haxe call PlayDate API:
  https://github.com/HaxeFoundation/hashlink/wiki/HashLink-native-extension-tutorial
  https://github.com/Aurel300/ammer
- Clean up the repo

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
