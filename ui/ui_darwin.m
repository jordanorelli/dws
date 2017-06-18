#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "EventBridge.h"

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

void set_root(char *path) {
	id listener = [[EventBridge shared] listener];
	[listener serverDidSetRoot:[NSString stringWithUTF8String:path]];
}
