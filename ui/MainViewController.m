#import "MainViewController.h"
#import "MainView.h"

@interface MainViewController ()

@property (nonatomic, strong) NSButton *selectDirectoryButton;

@end

@implementation MainViewController

- (void) loadView {
    NSLog(@"[MainViewController] loadView");
    self.view = [[MainView alloc] init];
}

- (void) viewDidLoad {
    NSLog(@"[MainViewController] viewDidLoad");
    [super viewDidLoad];

    [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:640.0].active = YES;
    [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:480.0].active = YES;

    self.selectDirectoryButton = [NSButton buttonWithTitle:@"select directory"
                                                    target:self
                                                    action:@selector(fart:)];
    [self.selectDirectoryButton setTranslatesAutoresizingMaskIntoConstraints:NO];


    [self.view addSubview:self.selectDirectoryButton];

    [self.selectDirectoryButton.rightAnchor
        constraintEqualToAnchor:self.view.rightAnchor
                       constant:-8.0].active = YES;
    [self.selectDirectoryButton.topAnchor
        constraintEqualToAnchor:self.view.topAnchor
                       constant:8.0].active = YES;
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

- (void) fart {
    NSLog(@"[MainViewController] fart!");
}

@end
