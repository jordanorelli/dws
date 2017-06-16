#include <Cocoa/Cocoa.h>
#include "AppDelegate.h"

id defaultAutoreleasePool;
id appDelegate;

void Initialize(void) {
    defaultAutoreleasePool = [NSAutoreleasePool new];
    [NSApplication sharedApplication];
    [NSApp setDelegate: [[AppDelegate new] autorelease]];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}

int Run(void) {
    [NSApp run];
    [defaultAutoreleasePool drain];
    return 0;
}
