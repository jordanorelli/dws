#import "EventBridge.h"

@implementation EventBridge

+ (instancetype) shared {
    static id instance;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        instance = [EventBridge new];
    });

    return instance;
}

@end
