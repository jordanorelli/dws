#import "AppDelegate.h"
#import "MainWindowController.h"

@implementation AppDelegate

// Application Startup ------------------------------------------------------{{{

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
    NSLog(@"[AppDelegate] Application Finished Launching");
    [self createMenubar];
    [self createMainWindow];
    NSLog(@"[AppDelegate] activate NSApp");
    [NSApp activateIgnoringOtherApps:YES];

}

// --------------------------------------------------------------------------}}}
// Application Termination --------------------------------------------------{{{

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    NSLog(@"[AppDelegate] applicationShouldTerminate sender: %@", sender);
    return NSTerminateNow;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    NSLog(@"[AppDelegate] applicationShouldTerminateAfterLastWindowClosed sender: %@", sender);
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"[AppDelegate] applicationWillTerminate notification sender: %@", notification);
}

// --------------------------------------------------------------------------}}}
// Menu Bar -----------------------------------------------------------------{{{

- (void) createMenubar {
    NSLog(@"[AppDelegate] Creating Menubar");

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
}

// --------------------------------------------------------------------------}}}
// Main Window --------------------------------------------------------------{{{

- (void) createMainWindow {
    NSLog(@"[AppDelegate] Creating Main Window");
    // TODO: make a singleton? retain in a property of appdelegate?
    // MainWindowController *windowController = [[[MainWindowController alloc] init] retain];
    MainWindowController *windowController = [[MainWindowController alloc] init];
    // NSLog(@"Window loaded: %d", [windowController isWindowLoaded]);
    [windowController showWindow:self];
}

// --------------------------------------------------------------------------}}}

@end

