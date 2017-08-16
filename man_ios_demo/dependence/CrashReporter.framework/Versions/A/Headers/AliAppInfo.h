//
//  AliAppInfo.h
//  CrashReporter
//
//  Created by qiulibin on 15/10/22.
//
//

#import <Foundation/Foundation.h>

@protocol TBCrashReporterAbortDelegate <NSObject>
@optional
/**
 *  发生crash时回调
 */
- (void)abortCallBack:(NSString *)state;

/**
 * 获取view数据
 */
- (NSString*)getCurrentView ;
@end



@interface AliAppInfo : NSObject{
    
}

@property (nonatomic, strong) id<TBCrashReporterAbortDelegate> delegate;
@property (nonatomic,strong) NSString* appVersion;
//@property (nonatomic,strong) NSString* userNick;
@property (nonatomic,strong) NSString* crashThreadStack;
@property (nonatomic,strong) NSString* currentView;
@property (nonatomic,strong) NSString* hpVersion;
@property  BOOL isGenerateLiveReport;

+ (instancetype)shareInstance;

@end
