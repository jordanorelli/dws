#import <Cocoa/Cocoa.h>
#import "ui_darwin.h"

@interface RequestHistory : NSObject <NSTableViewDataSource>
- (void) addRequestItem:(RequestMeta *)meta;
- (void) addResponseItem:(ResponseMeta *)meta;
@end
