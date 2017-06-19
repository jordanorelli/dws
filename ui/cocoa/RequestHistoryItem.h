#import <Cocoa/Cocoa.h>
#import "ui.h"

@interface RequestHistoryItem : NSObject

@property (readonly) int seq;
@property (readonly, strong) NSString *path;
@property (readonly) int status;
@property (readonly) int bytes;

+ (instancetype) itemWithRequestMeta:(RequestMeta *)meta;
- (instancetype) initWithRequestMeta:(RequestMeta *)meta;
- (void) updateWithResponseMeta:(ResponseMeta *)meta;

@end
