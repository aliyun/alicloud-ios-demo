#include "easy_port.h"
#ifdef HAVE_LIBSLIGHTSSL
#ifndef EASY_MULTISSL_H_
#define EASY_MULTISSL_H_


#include "easy_define.h"
#include "easy_io_struct.h"
EASY_CPP_START

void easy_multissl_send_cb(struct ev_loop *loop, ev_io *w, int revents);
void easy_multissl_client_handshake_cb(struct ev_loop *loop, ev_io *w, int revents);

int easy_multissl_client_do_handshake(easy_connection_t *c);
int easy_multissl_add_magic_number(easy_connection_t *c);
int easy_multissl_init(easy_io_t *eio);
int easy_multissl_client_destroy(easy_connection_t *c);
int easy_multissl_destroy(easy_io_t *eio);

EASY_CPP_END
#endif
#endif
