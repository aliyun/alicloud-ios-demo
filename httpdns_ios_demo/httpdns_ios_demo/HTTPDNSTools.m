//
//  HTTPDNSTools.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/5.
//

#import "HTTPDNSTools.h"

@implementation HTTPDNSTools

+ (BOOL)isValidString:(id)obj {
    if ((obj != nil) && ([obj isKindOfClass:[NSString class]])) {
        NSString *str = obj;
        return (str.length > 0);
    }
    return NO;
}

+ (id)storyBoardInstantiateViewController:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

@end
