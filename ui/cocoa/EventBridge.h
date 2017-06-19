#import <Cocoa/Cocoa.h>
#import "EventListener.h"

@interface EventBridge : NSObject
@property (assign) id <EventListener> listener;
+ (instancetype) shared;
@end
