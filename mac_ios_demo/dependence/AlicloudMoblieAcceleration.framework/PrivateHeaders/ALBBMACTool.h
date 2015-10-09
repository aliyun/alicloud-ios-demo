//
//  ALBBMACTool.h
//  ALINetworkSDK
//
//  Created by nanpo.yhl on 15-3-9.
//  Copyright (c) 2015年 nanpo.yhl. All rights reserved.
//

#ifndef ALINetworkSDK_ALBBMACTool_h
#define ALINetworkSDK_ALBBMACTool_h

#import <Foundation/Foundation.h>

#define DATA_COLLECTION  1

typedef enum
{
    SC_NORMAL = 0,  // 正常的http/https协议
    SC_SLIGHTSSL,   // slight - ssl协议
    SC_ACCS         // Accs协议
}SessionStyle;

@interface RequestDataCollection : NSObject
@property(nonatomic,assign)long long waiting;
@property(nonatomic,assign)long long sendBegin;
@property(nonatomic,assign)long long sendEnd;
@property(nonatomic,assign)long long recvBegin;
@property(nonatomic,assign)long long recvEnd;
@property(nonatomic,assign)int  recvBodySize;
@property(nonatomic,assign)int  recvHeadSize;
@property(nonatomic,assign)int  headerUncpSize;
@property(nonatomic,assign)int  headercpSize;
@property(nonatomic,assign)int  headBodySize;
@property(nonatomic,copy)NSString* host;

-(NSMutableDictionary*)getDictionary;
@end

@interface ConnectionDataCollection : NSObject
@property(nonatomic,assign)long long connBegin;
@property(nonatomic,assign)long long connEnd;
@property(nonatomic,assign)long long sslHandShakeBegin;
@property(nonatomic,assign)long long sslHandShakeEnd;
@property(nonatomic,assign)long long sslHandShakeCal;
@property(nonatomic,assign)int  connRetrys;
@property(nonatomic,assign)int  ticketReused;
@property(nonatomic,assign)int  proxy;
@property(atomic,assign)   BOOL isRequest;

-(NSDictionary*)getDictionary;
@end
#endif

//#pragma mark -
//#pragma mark 本地轨迹记录
//
//@interface ALBBMACTraceString : NSObject
//{
//}
//
//@property(nonatomic, strong)    NSMutableString     *trace;
//@property(nonatomic, strong)    id                  userDefineTrace;
//
//- (void)traceStr:(NSString*)info;
//- (void)traceFormat:(NSString*)format, ...;
//- (void)traceFormatWithTime:(NSString*)format, ...;
//- (void)traceFormat:(NSString*)format arguments:(va_list)args;
//
//// 不会跟时间的一组
//- (void)traceFormatNT:(NSString*)format, ...;
//- (void)traceFormatNT:(NSString*)format arguments:(va_list)args;
//
//- (NSString *)getTraceStr;
//- (void)reset;
//
//@end
