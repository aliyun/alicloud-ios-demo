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

#ifndef __NAL_TOOLS_H__
#define __NAL_TOOLS_H__ 
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include "easy_io_struct.h"

#define NAL_OK 0
#define NAL_ERROR -1
#define NAL_FAILED -2

#define DEFAULT_TIMEOUT 5000

typedef enum NAL_OPTION 
{
    TIMEOUT = 0,
    TCP_NODELAY
} NAL_OPTION;

typedef struct NAL_option {
    NAL_OPTION *name;
    uint8_t *value;
    int len;
} NAL_option;


typedef struct NAL_data {
    char* data;
    size_t len;
    bool fin;
} NAL_data;
typedef void* NAL_context;

typedef struct NAL_addr_t {
    uint16_t port;
    uint16_t proxy_port;
    union {
        uint32_t addr;
        uint8_t addr6[16];
        char* host;
    } u;
    union {
        uint32_t addr;
        uint8_t addr6[16];
        char *host;
    } proxy;
    uint32_t cidx;
} NAL_addr_t;

typedef enum NAL_protocol {
    NAL_HTTP,              //0
    NAL_ALBBMAC,
    NAL_QUIC,
    NAL_ACCS,
    NAL_StandardSSL,
    NAL_SlightSSL
} NAL_protocol;

typedef struct NAL_request_count_t {
    uint64_t request_start;
    uint64_t request_send_start;
    uint64_t request_send_end;
    uint64_t response_start;
    uint64_t response_end;
    int    request_header_raw;
    int    request_header_deflated;
    int    response_header_raw;
    int    response_header_inflated;
    int    request_body;
    int    response_body;
    int    retry_times;
} NAL_request_count_t;

typedef struct NAL_connection_count_t {
    uint64_t conn_start;
    uint64_t conn_end;
    
    int  retry_times;
    uint32_t timeout;
    uint64_t handshake_start;
    uint64_t handshake_end;
    uint64_t handshake_caltime;
    int  session_ticket_reused;
    
    //slight-ssl time
    uint64_t requesttime;
} NAL_connection_count_t;

#define NAL_HTTP_PROTOCOL_ERROR -1000

#endif
