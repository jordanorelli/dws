#import "_cgo_export.h"
#import "MainViewController.h"
#import "MainView.h"
#import "EventBridge.h"

@interface MainViewController ()

@property (nonatomic, strong) NSOpenPanel *selectDirectoryPanel;
@property (nonatomic, strong) NSButton *selectDirectoryButton;
@property (nonatomic, strong) NSTextField *selectedDirectoryText;

@end

@implementation MainViewController

- (void) loadView {
    NSLog(@"[MainViewController] loadView");
    self.view = [[MainView alloc] init];
}

- (void) viewDidLoad {
    NSLog(@"[MainViewController] viewDidLoad");
    [super viewDidLoad];

    // set window dimensions
    [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:640.0].active = YES;
    [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:480.0].active = YES;

    // create open panel
    self.selectDirectoryPanel = [NSOpenPanel openPanel];
    [self.selectDirectoryPanel setCanChooseFiles:NO];
    [self.selectDirectoryPanel setCanChooseDirectories:YES];

    // create select directory button
    self.selectDirectoryButton = [NSButton buttonWithTitle:@"select directory"
                                                    target:self
                                                    action:@selector(selectDirectory)];
    [self.selectDirectoryButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.selectDirectoryButton];

    // create label to show selected directory
	self.selectedDirectoryText = [NSTextField labelWithString:@"no directory selected"];
    [self.selectedDirectoryText setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.selectedDirectoryText];

    // place button in top right
    [self.selectDirectoryButton.rightAnchor
        constraintEqualToAnchor:self.view.rightAnchor
                       constant:-8.0].active = YES;
    [self.selectDirectoryButton.topAnchor
        constraintEqualToAnchor:self.view.topAnchor
                       constant:8.0].active = YES;

	// place directory selection in top left
	[self.selectedDirectoryText.leftAnchor
		constraintEqualToAnchor:self.view.leftAnchor
					   constant:8.0].active = YES;
	[self.selectedDirectoryText.topAnchor
		constraintEqualToAnchor:self.view.topAnchor
					   constant:8.0].active = YES;

	[[EventBridge shared] setListener:self];
}

- (void) selectDirectory {
    NSLog(@"[MainViewController] select directory start");
    [self.selectDirectoryPanel beginWithCompletionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton) {
            NSLog(@"[MainViewController] user canceled select directory window");
            return;
        }
        NSURL *selected = [[self.selectDirectoryPanel URLs] objectAtIndex:0];
        char *path = (char *)[[selected path] UTF8String];
		selectDirectory(path);
    }];
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

- (void) serverDidSetRoot:(NSString *)path {
	[self.selectedDirectoryText setStringValue:path];
}

@end
