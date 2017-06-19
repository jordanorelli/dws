#import "MainView.h"

@implementation MainView

- (instancetype)initWithFrame:(NSRect)frameRect {
    NSLog(@"[MainView] initWithFrame: %@", NSStringFromRect(frameRect));
    self = [super initWithFrame:frameRect];
    return self;
}

- (void) viewDidMoveToWindow {
    NSLog(@"[MainView] viewDidMoveToWindow: %@", self.window);
}

@end
