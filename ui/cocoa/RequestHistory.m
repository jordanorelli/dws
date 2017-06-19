#import "RequestHistory.h"
#import "RequestHistoryItem.h"

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
	RequestHistoryItem *item = [[self items] objectAtIndex:row];
	if (!item) {
		return nil;
	}

	if ([[column identifier] isEqualToString:@"id"]) {
		return [NSNumber numberWithInt:[item seq]];
	} else if ([[column identifier] isEqualToString:@"status"]) {
		if ([item status] == 0) {
			return @"???";
		} else {
			return [NSNumber numberWithInt:[item status]];
		}
	} else if ([[column identifier] isEqualToString:@"path"]) {
		return [item path];
	} else {
		return @"fuck";
	}
}

- (void) addRequestItem:(RequestMeta *)meta {
	NSLog(@"[RequestHistory] add request item");
	[[self items] addObject:[RequestHistoryItem itemWithRequestMeta:meta]];
}

- (void) addResponseItem:(ResponseMeta *)meta {
	NSLog(@"[RequestHistory] add response item");
	id item = [[self items] objectAtIndex:meta->seq-1];
	[item updateWithResponseMeta:meta];
}

@end
