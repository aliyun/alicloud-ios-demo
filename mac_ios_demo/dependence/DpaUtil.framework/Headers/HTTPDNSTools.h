
#import <Foundation/Foundation.h>

//#define HTTPDNS_LOGER   1

typedef enum {
    ADDSINGLEHOST,
    TTL
}ArgType;

@interface HTTPDNSTools : NSObject

+ (HTTPDNSTools *)sharedInstanceManage;

+ (BOOL)isLegalIP:(NSString *)ip;

+ (BOOL)isLegalHost:(NSString *)host;

+ (long long)currentTimeInSec;


- (void)httpDnsRequest:(NSNumber *) typeNumber;

- (BOOL)setTimeoutTaskFlags;

- (NSString *)getHttpDnsURL;

@end
