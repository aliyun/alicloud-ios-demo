//
//  NSString+Numeric.m
//  mpush_ios_demo
//
//  Created by Miracle on 2024/10/31.
//  Copyright © 2024 alibaba. All rights reserved.
//

#import "NSString+Numeric.h"

@implementation NSString (Numeric)

- (BOOL)isNumeric {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet:nonDigitCharacterSet];
    return r.location == NSNotFound && self.length > 0;
}

@end
