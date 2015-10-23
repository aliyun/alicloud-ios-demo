#include "easy_port.h"
#ifndef EASY_SLIGHTSSL_H_
#define EASY_SLIGHTSSL_H_

#include "easy_io.h"
#ifdef HAVE_LIBSLIGHTSSL
/*
 * 初始化、释放slightssl资源
 */
int easy_slightssl_init(easy_io_t *eio);
int easy_slightssl_cleanup(easy_io_t *eio);

/*
 * slightssl握手回调
 */
void easy_slightssl_client_handshake_cb(struct ev_loop *loop, ev_io *w, int revents);

/*
 * 直接slightssl握手, 会创建slightssl client
 */
void easy_slightssl_client_handshake(easy_connection_t *c);

/*
 * 关闭slightssl连接
 */
int easy_slightssl_client_destroy(easy_connection_t *c);

#endif
#endif
