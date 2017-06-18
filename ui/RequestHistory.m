#import "RequestHistory.h"

@interface RequestHistory ()
@property (strong) NSMutableArray *items;
@end

@implementation RequestHistory

- (instancetype) init {
	self = [super init];
	if (self) {
		[self setItems:[[NSMutableArray alloc] initWithCapacity:1000]];
	}
	return self;
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)view {
	return [[self items] count];
}

- (id) tableView:(NSTableView *)view objectValueForTableColumn:(NSTableColumn *)column row:(NSInteger) row {
	NSLog(@"[RequestHistory] objectValueForTableColumn: %@ row: %zd", column, row);
	return [[self items] objectAtIndex:row];
}

- (void) addRequestItem:(RequestMeta *)meta {
	NSLog(@"[RequestHistory] add request item");
	[[self items] addObject:[NSValue valueWithBytes:meta objCType:@encode(RequestMeta)]];
}

- (void) addResponseItem:(ResponseMeta *)meta {
	NSLog(@"[RequestHistory] add response item");
}

@end
