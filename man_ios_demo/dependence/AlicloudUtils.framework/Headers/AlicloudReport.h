//
//  AlicloudReport.h
//  AlicloudUtils
//
//  Created by ryan on 3/6/2016.
//  Copyright © 2016 Ali. All rights reserved.
//

#ifndef AlicloudReport_h
#define AlicloudReport_h

typedef enum _AMSService {
    AMSMAN  = 0,
    AMSHTTPDNS,
    AMSMPUSH,
    AMSMAC
} AMSService;

@interface AlicloudReport : NSObject

+ (void)statAsync:(AMSService)tag;
+ (BOOL)isDeviceReported:(AMSService)tag;

@end

#endif /* AlicloudReport_h */
