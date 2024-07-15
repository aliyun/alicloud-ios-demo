//
//  HTTPDNSUtils.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import "HTTPDNSUtils.h"

static NSString *const configInfoFileName = @"httpdns-domains";
static NSString *const configInfoFileType = @"plist";

@implementation HTTPDNSUtils

+ (NSArray *)domains {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:configInfoFileName ofType:configInfoFileType];
    if (![HTTPDNSTools isValidString:filePath]) {
        NSLog(@"Get domains is faild.");
        return nil;
    }

    NSArray *domains = [NSArray arrayWithContentsOfFile:filePath];
    return domains;
}

@end
