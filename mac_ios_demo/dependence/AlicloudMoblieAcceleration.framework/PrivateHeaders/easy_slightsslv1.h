#include "easy_port.h"
#ifndef EASY_SLIGHTSSLV1_H_
#define EASY_SLIGHTSSLV1_H_

#include "easy_io.h"
#ifdef HAVE_LIBSLIGHTSSL_V1
/*
 * 初始化、释放slightssl资源
 */
int easy_slightssl_init_v1(easy_io_t *eio);
int easy_slightssl_cleanup_v1(easy_io_t *eio);

/*
 * slightssl握手回调
 */
void easy_slightssl_client_handshake_cb_v1(struct ev_loop *loop, ev_io *w, int revents);

/*
 * 直接slightssl握手, 并创建slightssl连接
 */
void easy_slightssl_client_handshake_v1(easy_connection_t *c);

/*
 * 关闭slightssl连接
 */
int easy_slightssl_client_destroy_v1(easy_connection_t *c);

/*
 *设置性能回调函数
 */
int easy_slightssl_set_perf_cb_v1(easy_io_t *eio, easy_slightssl_perf_pt *on_perf);


#endif
#endif
