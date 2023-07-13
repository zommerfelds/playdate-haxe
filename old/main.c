//
//  main.c
//  Extension
//
//  Created by Dave Hayden on 7/30/14.
//  Copyright (c) 2014 Panic, Inc. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

#include "pd_api.h"
#include <Main.h>

static int update(void* userdata);
const char* fontpath = "/System/Fonts/Asheville-Sans-14-Bold.pft";
LCDFont* font = NULL;

#ifdef _WINDLL
__declspec(dllexport)
#endif
int eventHandler(PlaydateAPI* pd, PDSystemEvent event, uint32_t arg)
{
	(void)arg; // arg is currently only used for event = kEventKeyPressed

	if ( event == kEventInit )
	{
		const char* err;
		font = pd->graphics->loadFont(fontpath, &err);
		
		if ( font == NULL )
			pd->system->error("%s:%i Couldn't load font %s: %s", __FILE__, __LINE__, fontpath, err);

		// Note: If you set an update callback in the kEventInit handler, the system assumes the game is pure C and doesn't run any Lua code in the game
		pd->system->setUpdateCallback(update, pd);
	}
	
	return 0;
}


#define TEXT_WIDTH 86
#define TEXT_HEIGHT 16

int x = (400-TEXT_WIDTH)/2;
int y = (240-TEXT_HEIGHT)/2;
int dx = 1;
int dy = 2;

void onHaxeException(const char* info) {
	printf("Haxe exception: \"%s\"\n", info);
	// stop the haxe thread immediately
	Main_stopHaxeThreadIfRunning(false);
}

void exampleCallback(int num) {
	printf("exampleCallback(%d)\n", num);
}

int foo(void) {
	// start the haxe thread
	Main_initializeHaxeThread(onHaxeException);

	// create an instance of our haxe class
	HaxeObject instance = Main_UseMeFromC_new(exampleCallback);
	// to call members of instance, we pass the instance in as the first argument
	int result = Main_UseMeFromC_add(instance, 1, 2);
	// when we're done with our object we can tell the haxe-gc we're finished
	Main_releaseHaxeObject(instance);

	// call a static function
	HaxeString cStr = Main_UseMeFromC_exampleStaticFunction();
	printf("%s\n", cStr);
	Main_releaseHaxeString(cStr);

	// stop the haxe thread but wait for any scheduled events to complete
	Main_stopHaxeThreadIfRunning(true);

	return 0;
}

static int update(void* userdata)
{
	PlaydateAPI* pd = userdata;
	
	pd->graphics->clear(kColorWhite);
	pd->graphics->setFont(font);

	// Test
	int num = 7;
	// start the haxe thread
	// Main_initializeHaxeThread(onHaxeException);
	num = Main_UseMeFromC_myNum();
	char str[100] = "num=";
	sprintf(str + strlen(str), "%d", num);

	pd->graphics->drawText(str, strlen(str), kASCIIEncoding, x, y);

	x += dx;
	y += dy;
	
	if ( x < 0 || x > LCD_COLUMNS - TEXT_WIDTH )
		dx = -dx;
	
	if ( y < 0 || y > LCD_ROWS - TEXT_HEIGHT )
		dy = -dy;
        
	pd->system->drawFPS(0,0);

	return 1;
}

