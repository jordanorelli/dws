#import <Cocoa/Cocoa.h>

@protocol EventListener
- (void) serverDidSetRoot:(NSString *)path;
@end

