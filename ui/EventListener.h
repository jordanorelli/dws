#import <Cocoa/Cocoa.h>

@protocol EventListener
- (void) serverDidSetRoot:(NSString *)path;
- (void) serverDidBeginHandlingRequest;
- (void) serverDidFinishHandlingRequest;
@end

