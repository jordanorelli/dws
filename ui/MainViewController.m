#import "_cgo_export.h"
#import "MainViewController.h"
#import "MainView.h"
#import "EventBridge.h"

@interface MainViewController ()

@property (nonatomic, strong) NSOpenPanel *selectDirectoryPanel;
@property (nonatomic, strong) NSButton *selectDirectoryButton;
@property (nonatomic, strong) NSTextField *selectedDirectoryText;
@property (nonatomic, strong) NSScrollView *historyContainer;
@property (nonatomic, strong) NSTableView *historyTable;

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

	[self createOpenPanel];
	[self createDirectoryButton];
	[self createDirectoryLabel];
	[self createHistoryTable];
	[self createLayoutConstraints];

	[[EventBridge shared] setListener:self];
}

- (void) createOpenPanel {
    self.selectDirectoryPanel = [NSOpenPanel openPanel];
    [self.selectDirectoryPanel setCanChooseFiles:NO];
    [self.selectDirectoryPanel setCanChooseDirectories:YES];
}

- (void) createDirectoryButton {
    self.selectDirectoryButton = [NSButton buttonWithTitle:@"select directory"
                                                    target:self
                                                    action:@selector(selectDirectory)];
    [self.selectDirectoryButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.selectDirectoryButton];
}

- (void) createDirectoryLabel {
	self.selectedDirectoryText = [NSTextField labelWithString:@"no directory selected"];
    [self.selectedDirectoryText setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.selectedDirectoryText];
}

- (void) createHistoryTable {
	NSScrollView *tableContainer = [[NSScrollView alloc] init];
	[tableContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
	[tableContainer setHasVerticalScroller:YES];
	[tableContainer setFocusRingType:NSFocusRingTypeNone];
	[self.view addSubview:tableContainer];

	NSTableView *tableView = [[NSTableView alloc] init];
	[tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[tableView setFocusRingType:NSFocusRingTypeNone];
	[tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];

	NSTableColumn *idColumn = [[NSTableColumn alloc] initWithIdentifier:@"id"];
	[idColumn setTitle:@"id"];
	[idColumn setWidth:100];
	[tableView addTableColumn:idColumn];

	NSTableColumn *statusColumn = [[NSTableColumn alloc] initWithIdentifier:@"status"];
	[statusColumn setTitle:@"status"];
	[statusColumn setWidth:100];
	[tableView addTableColumn:statusColumn];

	NSTableColumn *pathColumn = [[NSTableColumn alloc] initWithIdentifier:@"path"];
	[pathColumn setTitle:@"path"];
	[pathColumn setWidth:200];
	[tableView addTableColumn:pathColumn];

	[tableContainer setDocumentView:tableView];
	[self setHistoryContainer:tableContainer];
	[self setHistoryTable:tableView];
}

- (void) createLayoutConstraints {
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

	// history table should fill the rest
	[self.historyContainer.topAnchor
		constraintEqualToAnchor:self.selectDirectoryButton.bottomAnchor
					   constant:8.0].active = YES;
	[self.historyContainer.leftAnchor
		constraintEqualToAnchor:self.view.leftAnchor
					   constant:8.0].active = YES;
	[self.historyContainer.rightAnchor
		constraintEqualToAnchor:self.view.rightAnchor
					   constant:-8.0].active = YES;
	[self.historyContainer.bottomAnchor
		constraintEqualToAnchor:self.view.bottomAnchor
					   constant:-8.0].active = YES;
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

- (void) serverDidSetRoot:(NSString *)path {
	[self.selectedDirectoryText setStringValue:path];
}

- (void) serverDidReceiveRequest:(RequestMeta *)meta {
	NSLog(@"[MainViewController] request start: {%d %s}", meta->seq, meta->path);
}

- (void) serverDidWriteResponse:(ResponseMeta *)meta {
	NSLog(@"[MainViewController] request finish: {%d %d %d}", meta->seq, meta->status, meta->bytes);
}

@end
