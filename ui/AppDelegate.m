#import "AppDelegate.h"

@implementation AppDelegate

// Application Startup ------------------------------------------------------{{{

- (void) applicationWillFinishLaunching:(NSNotification *)notification {
	NSLog(@"applicationWillFinishLaunching notification: %@", notification);
	NSLog(@"Main Menu in applicationWillFinishLaunching: %@", [NSApp mainMenu]);
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
	NSLog(@"applicationDidFinishLaunching notification: %@", notification);
	NSLog(@"Main Menu in applicationDidFinishLaunching: %@", [NSApp mainMenu]);
    [NSApp activateIgnoringOtherApps:YES];
}

// --------------------------------------------------------------------------}}}
// Application Termination --------------------------------------------------{{{

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	NSLog(@"applicationShouldTerminate sender: %@", sender);
	return NSTerminateNow;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	NSLog(@"applicationShouldTerminateAfterLastWindowClosed sender: %@", sender);
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	NSLog(@"applicationWillTerminate notification sender: %@", notification);
}

// --------------------------------------------------------------------------}}}
// Application Active Status ------------------------------------------------{{{

- (void)applicationWillBecomeActive:(NSNotification *)notification {
	NSLog(@"applicationWillBecomeActive notification: %@", notification);
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
	NSLog(@"applicationDidBecomeActive notification: %@", notification);
}

- (void)applicationWillResignActive:(NSNotification *)notification {
	NSLog(@"applicationWillResignActive notification: %@", notification);
}

- (void)applicationDidResignActive:(NSNotification *)notification {
	NSLog(@"applicationDidResignActive notification: %@", notification);
}

// --------------------------------------------------------------------------}}}
// Application Hide Status --------------------------------------------------{{{

- (void)applicationWillHide:(NSNotification *)notification {
	NSLog(@"applicationWillHide notification: %@", notification);
}

- (void)applicationDidHide:(NSNotification *)notification {
	NSLog(@"applicationDidHide notification: %@", notification);
}

- (void)applicationWillUnhide:(NSNotification *)notification {
	NSLog(@"applicationWillUnhide notification: %@", notification);
}

- (void)applicationDidUnhide:(NSNotification *)notification {
	NSLog(@"applicationDidUnhide notification: %@", notification);
}

// --------------------------------------------------------------------------}}}
// Application Update Status ------------------------------------------------{{{

- (void)applicationWillUpdate:(NSNotification *)notification {
	// NSLog(@"applicationWillUpdate notification: %@", notification);
}

- (void)applicationDidUpdate:(NSNotification *)notification {
	// NSLog(@"applicationDidUpdate notification: %@", notification);
}

// --------------------------------------------------------------------------}}}
// Menu Bar -----------------------------------------------------------------{{{

- (void) createMenuBar {
	NSLog(@"Will create menu bar here");
	NSLog(@"creating menu bar. initial main menu bar: %@", [NSApp mainMenu]);

	id mainMenu = [NSMenu alloc];
	[mainMenu initWithTitle:@"Main Menu"];
	[NSApp setMainMenu:mainMenu];

	id appMenuItem = [NSMenuItem alloc];
	[appMenuItem initWithTitle:@"dws" action:NULL keyEquivalent:@""];
	[mainMenu addItem:appMenuItem];

	id appMenu = [NSMenu alloc];
	[appMenu initWithTitle:@"dws"];
	[appMenuItem setSubmenu:appMenu];

	id quitMenuItem = [NSMenuItem alloc];
	[quitMenuItem initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
	[appMenu addItem:quitMenuItem];
	NSLog(@"assigned to main menu: %@", [NSApp mainMenu]);
}

// --------------------------------------------------------------------------}}}
@end

