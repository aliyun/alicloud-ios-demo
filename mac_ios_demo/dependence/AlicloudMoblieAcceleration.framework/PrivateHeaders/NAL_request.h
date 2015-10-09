/*
 * Network Apaptation Layer for Tnet Library.
 *
 * Copyright (c) Bin Yang <lingming.yb@alibaba-inc.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modifica-
 * tion, are permitted provided that the following conditions are met:
 *
 *   1.  Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *   2.  Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MER-
 * CHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPE-
 * CIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTH-
 * ERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 * Alternatively, the contents of this file may be used under the terms of
 * the GNU General Public License ("GPL") version 2 or any later version,
 * in which case the provisions of the GPL are applicable instead of
 * the above. If you wish to allow the use of your version of this file
 * only under the terms of the GPL and not to allow others to use your
 * version of this file under the BSD license, indicate your decision
 * by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL. If you do not delete the
 * provisions above, a recipient may use your version of this file under
 * either the BSD or the GPL.
 */

#ifndef __NAL_REQUEST_H__
#define __NAL_REQUEST_H__

#include "NAL_tools.h"
#include <stdbool.h>

typedef uint8_t NAL_request_priority;
typedef char* NAL_request_url;
typedef int NAL_timeout_t;

typedef struct NAL_head_map {
    char** keys;
    char** values;
    uint32_t len;
    void*  reserve;
} NAL_head_map;

typedef const char** NAL_head;

typedef struct NAL_request_handler {
     void (*NAL_request_ResponseHead)(NAL_head_map* head, uint32_t code, void* att);
     void (*NAL_request_ResponseData)(NAL_data* data, void* att, NAL_request_count_t* count_ptr);
     void (*NAL_request_Exception)(int error, int syserrorno, void* att);
}NAL_request_handler;

typedef struct NAL_request_meta {
    NAL_request_handler handler;
    NAL_context context;    // Used for jni penetration.
} NAL_request_meta;

typedef struct NAL_request_t {
    NAL_request_priority priority;
    NAL_timeout_t   timeout;
    NAL_option option;
    NAL_head head;
    NAL_request_url url;
    NAL_data request_data;
    NAL_request_meta meta;
    int ssl_type;
} NAL_request_t;

NAL_request_t* NAL_request_Create();
void NAL_request_Destory(NAL_request_t* request);
void NAL_request_SetHead(NAL_request_t* request, char **nv);
void NAL_request_SetUrl(NAL_request_t* request, char *url);
void NAL_request_SetTimeout(NAL_request_t* request,NAL_timeout_t timeout);
void NAL_request_SetOption(NAL_request_t* request, NAL_option option);
void NAL_request_SetHandler(NAL_request_t* request, NAL_request_handler handler);
void NAL_request_SetContext(NAL_request_t* request, void *context);
void NAL_request_SetSSLType(NAL_request_t* request, int type);


#endif
