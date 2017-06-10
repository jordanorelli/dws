#import "AppDelegate.h"

@implementation AppDelegate

- (void) applicationWillFinishLaunching:(NSNotification *)notification {
	NSLog(@"applicationWillFinishLaunching");
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
	NSLog(@"applicationDidFinishLaunching");
}

// Application Termination -----------------------------------------------------

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	NSLog(@"applicationShouldTerminate");
	return NSTerminateNow;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	NSLog(@"applicationShouldTerminateAfterLastWindowClosed");
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	NSLog(@"applicationWillTerminate");
}

@end

