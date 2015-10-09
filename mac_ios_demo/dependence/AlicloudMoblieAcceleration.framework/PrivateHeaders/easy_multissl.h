#include "easy_port.h"
#ifdef EASY_USE_MULTISSL
#ifndef EASY_MULTISSL_H_
#define EASY_MULTISSL_H_

//idx是占4比特位
#define EASY_MULTISSL_PING               15
#define EASY_MULTISSL_RAW               0

#include "easy_define.h"
#include "easy_io_struct.h"
EASY_CPP_START

void easy_multissl_send_cb(struct ev_loop *loop, ev_io *w, int revents);
void easy_multissl_client_handshake_cb(struct ev_loop *loop, ev_io *w, int revents);

int easy_multissl_client_do_handshake(easy_connection_t *c);
int easy_multissl_add_magic_number(easy_connection_t *c);
int easy_multissl_client_destroy(easy_connection_t *c);

EASY_CPP_END
#endif
#endif
