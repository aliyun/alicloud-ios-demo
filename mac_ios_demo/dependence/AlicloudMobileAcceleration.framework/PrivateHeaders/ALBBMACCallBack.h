//
//  ALBBMACCallBack.h
//  ALINetworkSDK
//
//  Created by nanpo.yhl on 15-3-9.
//  Copyright (c) 2015年 nanpo.yhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAL_request.h"

/*
 * http handler
 */
void recvResponseHead(NAL_head_map* head, uint32_t code, void*  att);

void recvResponseData(NAL_data* data, void* att, NAL_request_count_t* count_ptr);

void handlerException(int errorCode, int syserrorno, void* att);



/*
 * tcp handler
 *
 */
void sessionWithError(int errorCode, int syserrorno, void* context);

int  recvSessionPing(void* context, int index, bool flags);

void sessionWithDisconnect(void *context, int errorCode, int syserrorno);

void sessionWithConnFail(void *context, int retry, int errorCode, int syserrorno);

void sessionWithConnect(void *context, NAL_connection_count_t *count_ptr);

int sessionIdleEventCallBack(void *context);

int getSessionIdleTimeoutCallBack(void *context);