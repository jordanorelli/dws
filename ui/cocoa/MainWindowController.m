#import "MainWindowController.h"
#import "MainViewController.h"

@implementation MainWindowController

- (id) init {
    id viewController = [[MainViewController alloc] init];
    NSLog(@"[MainWindowController] init: view loaded: %d", [viewController isViewLoaded]);

    id window = [[NSWindow windowWithContentViewController:viewController] retain];
    NSLog(@"[MainWindowController] window: %@", window);
    NSLog(@"[MainWindowController] init (2): view loaded: %d", [viewController isViewLoaded]);
    return [self initWithWindow:window];
}

- (instancetype) initWithWindow:(NSWindow *)window {
    NSLog(@"[MainWindowController] initWithWindow: %@", window);
    return [super initWithWindow:window];
}

- (instancetype)initWithWindowNibName:(NSString*)windowNibName {
    NSLog(@"[MainWindowController] initWithWindowNibName");
    return [super initWithWindowNibName:windowNibName];
}

- (instancetype)initWithWindowNibName:(NSString*)windowNibName 
                                owner:(id)owner {
    NSLog(@"[MainWindowController] initWithWindowNibNameOwner");
    return [super initWithWindowNibName:windowNibName];
}

- (instancetype)initWithWindowNibPath:(NSString *)windowNibPath 
                                owner:(id)owner {
    NSLog(@"[MainWindowController initWithWindowNibPath:owner");
    return [super initWithWindowNibPath:windowNibPath
                                  owner:owner];
}

- (void) windowWillLoad {
    NSLog(@"[MainWindowController] windowWillLoad");
    return [super windowWillLoad];
}

- (void) windowDidLoad {
    NSLog(@"[MainWindowController] windowDidLoad");
    return [super windowDidLoad];
}

- (void) loadWindow {
    NSLog(@"[MainWindowController] loadWindow");
    return [super loadWindow];
}

- (IBAction) showWindow:(id)sender {
    NSLog(@"[MainWindowController] showWindow");
    return [super showWindow:sender];
}

@end
