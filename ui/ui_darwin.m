#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "EventBridge.h"
#import "ui_darwin.h"

id defaultAutoreleasePool;
id appDelegate;

void ui_init() {
    defaultAutoreleasePool = [NSAutoreleasePool new];
    [NSApplication sharedApplication];
    [NSApp setDelegate: [[AppDelegate new] autorelease]];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}

int ui_run() {
    [NSApp run];
    [defaultAutoreleasePool drain];
    return 0;
}

void bg_shutdown() {
	[[NSApplication sharedApplication] terminate:nil];
}

void bg_set_root(char *path) {
	id listener = [[EventBridge shared] listener];
	[listener serverDidSetRoot:[NSString stringWithUTF8String:path]];
}

void bg_received_request(RequestMeta *meta) {
	id listener = [[EventBridge shared] listener];
	[listener serverDidReceiveRequest:meta];
}

void bg_sent_response(ResponseMeta *meta) {
	id listener = [[EventBridge shared] listener];
	[listener serverDidWriteResponse:meta];
}
