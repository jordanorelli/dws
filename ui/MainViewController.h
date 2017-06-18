#import <Cocoa/Cocoa.h>
#import "EventListener.h"

@interface MainViewController : NSViewController <EventListener, NSTableViewDataSource>
@end
