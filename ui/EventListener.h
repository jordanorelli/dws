#import <Cocoa/Cocoa.h>
#import "ui_darwin.h"

@protocol EventListener
- (void) serverDidSetRoot:(NSString *)path;
- (void) serverDidReceiveRequest:(RequestMeta *)meta;
- (void) serverDidWriteResponse:(ResponseMeta *)meta;
@end

