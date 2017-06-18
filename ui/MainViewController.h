#import <Cocoa/Cocoa.h>
#import "EventListener.h"

@interface MainViewController : NSViewController <EventListener>
- (void) serverDidSetRoot:(NSString *)path;
@end
