//
//  HttpDNSDegradationDelegate.h
//  httpdns_api_demo
//
//  Created by ryan on 21/1/2016.
//  Copyright © 2016 com.aliyun.mobile. All rights reserved.
//

#ifndef HttpDNSDegradationDelegate_h
#define HttpDNSDegradationDelegate_h

@protocol HttpDNSDegradationDelegate <NSObject>

- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName;

@end

#endif /* HttpDNSDegradationDelegate_h */
