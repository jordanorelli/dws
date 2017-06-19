#import <Cocoa/Cocoa.h>
#import "ui.h"

@interface RequestHistory : NSObject <NSTableViewDataSource>
- (void) addRequestItem:(RequestMeta *)meta;
- (void) addResponseItem:(ResponseMeta *)meta;
@end
