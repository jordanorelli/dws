#import <Cocoa/Cocoa.h>
#import "ui_darwin.h"

@protocol EventListener
- (void) serverDidSetRoot:(NSString *)path;
- (void) serverDidBeginHandlingRequest:(RequestMeta *)meta;
- (void) serverDidFinishHandlingRequest;
@end

