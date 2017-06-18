#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "EventBridge.h"
#import "ui_darwin.h"

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

void received_request(RequestMeta *meta) {
	id listener = [[EventBridge shared] listener];
	[listener serverDidReceiveRequest:meta];
}

void sent_response(ResponseMeta *meta) {
	id listener = [[EventBridge shared] listener];
	[listener serverDidWriteResponse:meta];
}
