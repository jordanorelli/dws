#import "MainViewController.h"
#import <objc/runtime.h>
#import "MainView.h"

@implementation MainViewController {
    NSButton *firstButton; 
}

- (void) loadView {
    NSLog(@"[MainViewController] loadView");
    self.view = [[MainView alloc] initWithFrame:NSMakeRect(0, 0, 640, 480)];
}

- (void) viewDidLoad {
    NSLog(@"[MainViewController] viewDidLoad");
    [super viewDidLoad];

    firstButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 120, 20)];
    [firstButton setButtonType:NSToggleButton];
    [firstButton setTitle:@"fart"];

    int i=0;
    unsigned int mc = 0;
    Method * mlist = class_copyMethodList(object_getClass(firstButton), &mc);
    NSLog(@"%d methods", mc);
    for(i=0;i<mc;i++)
        NSLog(@"Method no #%d: %s", i, sel_getName(method_getName(mlist[i])));

    [self.view addSubview:firstButton];
}

- (void) viewWillAppear {
    NSLog(@"[MainViewController] viewWillAppear");
    return [super viewWillAppear];
}

- (void) viewDidAppear {
    NSLog(@"[MainViewController] viewDidAppear");
    return [super viewDidAppear];
}

- (void) viewWillDisappear {
    NSLog(@"[MainViewController] viewWillDisappear");
    return [super viewWillDisappear];
}

- (void) viewDidDisappear {
    NSLog(@"[MainViewController] viewDidDisappear");
    return [super viewDidDisappear];
}

- (void) viewWillLayout {
    NSLog(@"[MainViewController] viewWillLayout");
    return [super viewWillLayout];
}

- (void) viewDidLayout {
    NSLog(@"[MainViewController] viewDidLayout");
    return [super viewDidLayout];
}
@end
