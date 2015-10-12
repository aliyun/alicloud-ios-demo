//
//  MANClientRequest.m
//  man_ios_demo
//
//  Created by nanpo.yhl on 15/10/10.
//  Copyright (c) 2015年 com.aliyun.mobile. All rights reserved.
//

#import "MANClientRequest.h"

@implementation MANClientRequest

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_bulider requestFirstBytes];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_bulider requestEndWithBytes:_mutableData.length];
    [_bulider build];
    [_bulider send];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    [_bulider requestEnd:_mutableData.length];
//    [_bulider build];
//    [_bulider send];
}

@end
