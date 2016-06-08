//
//  AliAppInfo.h
//  CrashReporter
//
//  Created by qiulibin on 15/10/22.
//
//

#import <Foundation/Foundation.h>

@interface AliAppInfo : NSObject{

}
    
@property (nonatomic,strong) NSString* appVersion;
//@property (nonatomic,strong) NSString* userNick;
@property (nonatomic,strong) NSString* crashThreadStack;
@property BOOL isGenerateLiveReport;

+ (instancetype)shareInstance;

@end
