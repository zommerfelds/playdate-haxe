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

# List C source files here
#SRC = src/main.c bin/libMain.a
# TODO: compile hashlink for arm. libhl.a might not work
SRC = out/main.c src/main_haxe.c /home/czom/private/hashlink-1.14/libhl.a
# /home/czom/private/hashlink-1.14/src/hl.h

# List all user directories here
#UINCDIR = bin
UINCDIR = out /home/czom/private/hashlink-1.14/src /usr/include/unicode /usr/include

#  /usr/arm-linux-gnueabi/include
# /usr/include/x86_64-linux-gnu
# NOTE: I'm not sure if it's right to add those above: /usr/include/unicode /usr/include
# /home/czom/private/hashlink-1.14/src

# List user asm files
UASRC = 

# List all user C define here, like -D_DEBUG=1
UDEFS = -Dchar16_t=uint16_t -D_Float128=double

# Define ASM defines here
UADEFS = 

# List the user directory to look for the libraries here
ULIBDIR = 
#bin

# List all user libraries here
ULIBS = 
#libMain.a

include $(SDK)/C_API/buildsupport/common.mk

PDCFLAGS = --skip-unknown

