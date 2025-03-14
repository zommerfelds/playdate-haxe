HEAP_SIZE      = 8388208
STACK_SIZE     = 61800

PRODUCT = HelloWorld.pdx

# Locate the SDK
SDK = ${PLAYDATE_SDK_PATH}
ifeq ($(SDK),)
	SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
endif

ifeq ($(SDK),)
$(error SDK path not found; set ENV value PLAYDATE_SDK_PATH)
endif

######
# IMPORTANT: You must add your source folders to VPATH for make to find them
# ex: VPATH += src1:src2
######

VPATH += src

HASHLINK_PATH ?= hashlink-1.14

# List C source files here
HASHLINK_SRC = $(HASHLINK_PATH)/src/gc.c \
	$(HASHLINK_PATH)/src/code.c \
	$(HASHLINK_PATH)/src/module.c \
	$(HASHLINK_PATH)/src/std/array.c \
	$(HASHLINK_PATH)/src/std/buffer.c \
	$(HASHLINK_PATH)/src/std/bytes.c \
	$(HASHLINK_PATH)/src/std/cast.c \
	$(HASHLINK_PATH)/src/std/error.c \
	$(HASHLINK_PATH)/src/std/fun.c \
	$(HASHLINK_PATH)/src/std/maps.c \
	$(HASHLINK_PATH)/src/std/obj.c \
	$(HASHLINK_PATH)/src/std/random.c \
	$(HASHLINK_PATH)/src/std/string.c \
	$(HASHLINK_PATH)/src/std/types.c \
	$(HASHLINK_PATH)/src/std/ucs2.c \
	$(HASHLINK_PATH)/src/std/track.c \
	$(HASHLINK_PATH)/src/std/thread.c \
	$(HASHLINK_PATH)/src/std/sys.c \
# no jit.c date.c

# uncomment this one if compiling for the simulator
#SRC = out/main.c src/main_haxe.c hashlink-1.14/libhl.a
SRC = out/main.c src/main_haxe.c $(HASHLINK_SRC) # hashlink-1.14/libhl.a

# inspired by https://github.com/ncannasse/hlos/blob/959fb60e91a8a59452f4d0f1c88b6af8da6ade93/Makefile

# List all user directories here
#UINCDIR = bin
UINCDIR = out /usr/include/unicode /usr/include $(HASHLINK_PATH)/src empty

#  /usr/arm-linux-gnueabi/include
# /usr/include/x86_64-linux-gnu
# NOTE: I'm not sure if it's right to add those above: /usr/include/unicode /usr/include

# List user asm files
UASRC = 

# List all user C define here, like -D_DEBUG=1
UDEFS = -DRTLD_DEFAULT=NULL -Dchar16_t=uint16_t -D_Float128=double -ffreestanding -flto -nostdlib  -DHL_NO_THREADS -DHL_OS

# Define ASM defines here
UADEFS = 

# List the user directory to look for the libraries here
ULIBDIR = 
#bin

# List all user libraries here
# Remove this if compiling for simulator
ULIBS = #hashlink-1.14/libhl.a
#libMain.a

include $(SDK)/C_API/buildsupport/common.mk

PDCFLAGS = --skip-unknown

