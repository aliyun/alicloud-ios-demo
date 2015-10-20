
#import <Foundation/Foundation.h>
#import "HTTPDNSOrigin.h"
#include "HTTPDNSTools.h"

@interface HTTPDNSMini : NSObject

+ (HTTPDNSMini *)sharedInstanceManage;


- (NSString *)getIpByHostAsync:(NSString *)host;

- (NSString *)getIpByHost:(NSString *)host;
@end
