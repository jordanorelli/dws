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
    [self createMenubar];
    [self createMainWindow];
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

- (void) createMenubar {
    NSLog(@"Will create menu bar here");
    NSLog(@"creating menu bar. initial main menu bar: %@", [NSApp mainMenu]);

    id mainMenu = [[NSMenu alloc] autorelease];
    [mainMenu initWithTitle:@"Main Menu"];
    [NSApp setMainMenu:mainMenu];

    id appMenuItem = [[NSMenuItem alloc] autorelease];
    [appMenuItem initWithTitle:@"dws" action:NULL keyEquivalent:@""];
    [mainMenu addItem:appMenuItem];

    id appMenu = [[NSMenu alloc] autorelease];
    [appMenu initWithTitle:@"dws"];
    [appMenuItem setSubmenu:appMenu];

    id quitMenuItem = [[NSMenuItem alloc] autorelease];
    [quitMenuItem initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [appMenu addItem:quitMenuItem];
    NSLog(@"assigned to main menu: %@", [NSApp mainMenu]);
}

// --------------------------------------------------------------------------}}}
// Main Window --------------------------------------------------------------{{{

- (void) createMainWindow {
    NSUInteger windowStyle = NSTitledWindowMask
                           | NSClosableWindowMask
                           | NSResizableWindowMask;

    id window = [NSWindow alloc];
    [window initWithContentRect:NSMakeRect(0, 0, 640, 480)
                      styleMask:windowStyle
                        backing:NSBackingStoreBuffered
                          defer:NO];

    [window cascadeTopLeftFromPoint:NSMakePoint(20, 20)];
    [window setTitle:@"dws"];
    [window makeKeyAndOrderFront:NSApp];
}

// --------------------------------------------------------------------------}}}

@end

