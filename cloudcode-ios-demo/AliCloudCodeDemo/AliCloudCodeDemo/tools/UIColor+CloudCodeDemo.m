//
//  UIColor+CloudCodeDemo.m
//  AliCloudCodeDemo
//
//  Created by yannan on 2022/1/21.
//

#import "UIColor+CloudCodeDemo.h"

@implementation UIColor (CloudCodeDemo)

static BOOL cloudCodeDemo_hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    str = [[str stringByTrimmingCharactersInSet:set] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = cloudCodeDemo_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

static inline NSUInteger cloudCodeDemo_hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}


+ (instancetype)cloudCodeDemo_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (cloudCodeDemo_hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}



+ (UIColor *)cloudCodeDemo_randomColor {
    return  [UIColor colorWithRed:(arc4random_uniform(256))/255.0 green:(arc4random_uniform(256))/255.0 blue:(arc4random_uniform(256))/255.0 alpha:1];
}


@end
