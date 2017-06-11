#include <Cocoa/Cocoa.h>
#include "AppDelegate.h"

id defaultAutoreleasePool;
id appDelegate;

void Initialize(void) {
    NSLog(@"Initializing with processInfo: %@", [[NSProcessInfo processInfo] arguments]);
	NSLog(@"Creating Autorelease Pool");
    defaultAutoreleasePool = [NSAutoreleasePool new];
    [NSApplication sharedApplication];
	NSLog(@"Setting App Delegate");
	appDelegate = [AppDelegate new];
	[appDelegate createMenuBar];
	[NSApp setDelegate: appDelegate];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
	NSLog(@"Initialization complete");
}


int Run(void) {
	NSLog(@"Entered Run");
	NSLog(@"Activating App");
	NSLog(@"Running App Event Loop");
    [NSApp run];
	NSLog(@"App Event Loop finished. Draining pool.");
	[defaultAutoreleasePool drain];
	NSLog(@"Leaving Run");
    return 0;
}
