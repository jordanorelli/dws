#import "RequestHistoryItem.h"

@implementation RequestHistoryItem

+ (instancetype) itemWithRequestMeta:(RequestMeta *)meta {
	return [[self alloc] initWithRequestMeta:meta];
}

- (instancetype) initWithRequestMeta:(RequestMeta *)meta {
	self = [super init];
	if (self) {
		_seq = meta->seq;
		_path = [NSString stringWithUTF8String:meta->path];
	}
	return self;
}

- (void) updateWithResponseMeta:(ResponseMeta *)meta {
	if (meta->seq != self.seq) {
		return;
	}
	_status = meta->status;
	_bytes = meta->bytes;
}

@end
