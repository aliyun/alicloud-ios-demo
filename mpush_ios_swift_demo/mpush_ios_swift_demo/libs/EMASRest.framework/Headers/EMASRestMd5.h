//
//  UTMd5.h
//

#import <Foundation/Foundation.h>

@interface EMASRestMd5 : NSObject


+ (NSString *)md5StrForData:(NSData *)data;

+ (NSData *)md5ForData:(NSData *)data;

+ (NSString *)md5StrForNSString:(NSString *) str;

@end
