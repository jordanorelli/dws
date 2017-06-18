#include <Cocoa/Cocoa.h>
#include "AppDelegate.h"

id defaultAutoreleasePool;
id appDelegate;

void initialize() {
    defaultAutoreleasePool = [NSAutoreleasePool new];
    [NSApplication sharedApplication];
    [NSApp setDelegate: [[AppDelegate new] autorelease]];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}

int run() {
    [NSApp run];
    [defaultAutoreleasePool drain];
    return 0;
}

void shutdown() {
	[[NSApplication sharedApplication] terminate:nil];
}
