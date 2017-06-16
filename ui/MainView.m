#import "MainView.h"

@implementation MainView

- (instancetype)initWithFrame:(NSRect)frameRect {
    NSLog(@"[MainView] initWithFrame: %@", NSStringFromRect(frameRect));
    self = [super initWithFrame:frameRect];

    // NSTextField *textField = [[NSTextField alloc] init];
    // [self addSubview:textField];
    // textField.translatesAutoresizingMaskIntoConstraints = NO;

    return self;
}

- (void) viewDidMoveToWindow {
    NSLog(@"[MainView] viewDidMoveToWindow: %@", self.window);
}

@end
