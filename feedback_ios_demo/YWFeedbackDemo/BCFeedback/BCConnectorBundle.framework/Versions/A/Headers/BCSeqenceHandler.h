//
//  WQSeqenceHandler.h
//  WQOpenSDK
//
//  Created by qinghua.liqh on 14-3-21.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "BCHandler.h"
#define WQSeqenceHandlerRunner BCSeqenceHandlerRunner
#define WQSeqenceHandler BCSeqenceHandler

@class WQSeqenceHandler;

@interface WQSeqenceHandlerRunner : NSObject
@property (strong, nonatomic) WQHandlerReturnBlock retBlock;
@property (weak, nonatomic)   WQSeqenceHandler *handler;
@property (strong, nonatomic) NSDictionary *params;
@property (strong, nonatomic) NSDictionary *extraParams;

- (id) initWithHandler:(WQSeqenceHandler *)handler retBlock:(WQHandlerReturnBlock)block params:(NSDictionary *)params extraParams:(NSDictionary *)extraParams;
@end


@interface WQSeqenceHandler : WQHandler
- (id)initWithEvent:(NSString *)event shouldOpenUI:(BOOL)shouldOpenUI;

- (void)beginRunner:(WQSeqenceHandlerRunner *)runner;
- (void)endRunner:(WQSeqenceHandlerRunner *)runner;
@end

