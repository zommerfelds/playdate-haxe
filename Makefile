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
SRC = out/main.c src/main_haxe.c /home/czom/private/hashlink-1.13/libhl.a
# /home/czom/private/hashlink-1.13/src/hl.h

# List all user directories here
#UINCDIR = bin
UINCDIR = out /home/czom/private/hashlink-1.13/src
# /home/czom/private/hashlink-1.13/src

# List user asm files
UASRC = 

# List all user C define here, like -D_DEBUG=1
UDEFS = 

# Define ASM defines here
UADEFS = 

# List the user directory to look for the libraries here
ULIBDIR = 
#bin

# List all user libraries here
ULIBS = 
#libMain.a

include $(SDK)/C_API/buildsupport/common.mk

