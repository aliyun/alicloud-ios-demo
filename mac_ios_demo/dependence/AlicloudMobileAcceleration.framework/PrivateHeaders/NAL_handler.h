/*
 * Network Apaptation Layer for Tnet Library.
 *
 * Copyright (c) Bin Yang
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
#ifndef __NAL_HANDLER_H__
#define __NAL_HANDLER_H__ 

#include "easy_io.h"
#include "NAL_request.h"

int NAL_process(easy_request_t *r, char *data, int len);
int NAL_session_on_init(easy_connection_t *c);
int NAL_session_on_ping(easy_request_t *r, int index);
int NAL_session_on_connect(easy_connection_t *c);
int NAL_session_on_connfail(easy_connection_t *c);
int NAL_session_on_disconnect(easy_connection_t *c);
int NAL_session_set_option(easy_task_t *t, easy_connection_t *c);
int NAL_task(easy_task_t *t, easy_connection_t *c);
int NAL_session_idle(easy_connection_t *c);
int error2error(int code, int detail);

//slight -ssl
void NAL_session_handshake_done(easy_connection_t *c);

//custom_frame
void NAL_process_custom_frame(easy_message_t *m, uint16_t type, uint8_t flags, int32_t length, char *data);

// callback put session to user
int NAL_session_putSSLMeta(easy_connection_t *c, char* ssl_meta, int len);

// callback get session from user
int NAL_session_getSSLMeta(easy_connection_t *c, char* ssl_meta, int* len);

//  bio ping call back
int NAL_session_on_bio_ping(easy_message_t *m, uint32_t id);
#endif
