#ifndef EASY_IO_H_
#define EASY_IO_H_

#include "easy_define.h"
#include <unistd.h>
#include <pthread.h>
#include "easy_io_struct.h"
#include "easy_log.h"
/**
 * IO文件头
 */

EASY_CPP_START

// 接口函数
///////////////////////////////////////////////////////////////////////////////////////////////////
// easy_io_t
extern void                 easy_inspect();
extern easy_io_t           *easy_eio_create(easy_io_t *eio, int io_thread_count);
extern int                  easy_eio_start(easy_io_t *eio);
extern int                  easy_eio_wait(easy_io_t *eio);
extern int                  easy_eio_stop(easy_io_t *eio);
extern void                 easy_eio_destroy(easy_io_t *eio);

extern struct ev_loop      *easy_eio_thread_loop(easy_io_t *eio, int index);
extern void easy_eio_set_thread_cb(easy_io_t *eio, easy_io_thread_cb_pt *on_begin, easy_io_thread_cb_pt *on_end, void *user_data);

///////////////////////////////////////////////////////////////////////////////////////////////////
// easy_connection_t
extern easy_connection_t   *easy_connection_connect_thread(easy_io_t *eio, easy_addr_t addr,
        easy_io_handler_pt *handler, int conn_timeout, void *args, int flags);
extern int                  easy_connection_connect(easy_io_t *eio, easy_addr_t addr,
        easy_io_handler_pt *handler, int conn_timeout, void *args, int flags);
extern int                  easy_connection_disconnect(easy_io_t *eio, easy_addr_t addr);
extern int                  easy_connection_disconnect_ex(easy_io_t *eio, easy_addr_t addr, easy_session_t *s);
extern int                  easy_connection_disconnect_all(easy_io_t *eio, uint32_t idx);
extern int                  easy_connection_disconnect_thread(easy_io_t *eio, easy_addr_t addr);
extern int                  easy_connection_disconnect_direct(easy_io_t *eio, easy_addr_t addr);
extern int                  easy_connection_disconnect_direct_thread(easy_io_t *eio, easy_addr_t addr);
extern char                 *easy_connection_str(easy_connection_t *c);

extern easy_session_t       *easy_connection_connect_init(easy_session_t *s, easy_io_handler_pt *handler,
        int conn_timeout, void *args, int flags, char *servername);
extern easy_connection_t    *easy_connection_connect_thread_ex(easy_addr_t addr, easy_session_t *s);
extern int                  easy_connection_connect_ex(easy_io_t *eio, easy_addr_t addr, easy_session_t *s);
///////////////////////////////////////////////////////////////////////////////////////////////////
// easy_session
extern easy_session_t      *easy_session_create(int64_t size);
extern void                 easy_session_destroy(void *s);
extern easy_task_t *easy_task_create(int64_t asize);
///////////////////////////////////////////////////////////////////////////////////////////////////
extern int                  easy_client_dispatch(easy_io_t *eio, easy_addr_t addr, easy_session_t *s);
///////////////////////////////////////////////////////////////////////////////////////////////////
// easy_request
extern int                  easy_request_do_reply(easy_request_t *r);
extern void                 easy_request_addbuf(easy_request_t *r, easy_buf_t *b);
extern void                 easy_request_addbuf_list(easy_request_t *r, easy_list_t *list);
///////////////////////////////////////////////////////////////////////////////////////////////////
// easy_ssl
#ifdef HAVE_LIBSSL
extern int                  easy_ssl_init();
extern int                  easy_ssl_cleanup();
extern easy_ssl_t          *easy_ssl_config_load(char *filename);
extern easy_ssl_t          *easy_ssl_config_create();
extern int                  easy_ssl_config_build(easy_ssl_t *ssl);
extern int                  easy_ssl_config_destroy(easy_ssl_t *ssl);
extern int easy_ssl_client_authenticate(easy_ssl_t *ssl, SSL *conn, const void *host, int len);
#endif

//v1
#ifdef HAVE_LIBSLIGHTSSL_V1
extern int easy_slightssl_init_v1(easy_io_t *eio);
extern int easy_slightssl_cleanup_v1(easy_io_t *eio);
extern int easy_slightssl_set_perf_cb_v1(easy_io_t *eio, easy_slightssl_perf_pt *on_perf);
#include "easy_compat_start.h"
#define easy_slightssl_set_cert_cb_v1(eio, c) SLIGHT_SSL_CTX_set_cert_cb((eio)->ss_ctx_v1, c)
#define easy_slightssl_set_pubkey_cb_v1(eio, p) SLIGHT_SSL_CTX_set_pubkey_cb((eio)->ss_ctx_v1, p)
#include "easy_compat_end.h"
#endif

//v2
#ifdef HAVE_LIBSLIGHTSSL
extern int easy_slightssl_init(easy_io_t *eio);
extern int easy_slightssl_cleanup(easy_io_t *eio);
#endif

extern int easy_bio_ping(easy_io_t *eio, easy_addr_t addr);

///////////////////////////////////////////////////////////////////////////////////////////////////
// define
#define EASY_IOTH_SELF ((easy_io_thread_t*) easy_baseth_self)
#define easy_session_set_flag(s, f)     (s)->packet_id |= (f)
#define easy_session_set_args(s, a)     (s)->r.args = (void*)a
#define easy_session_set_timeout(s, t)  (s)->timeout = t
#define easy_session_set_conn_timeout(s, t)  (s)->conn_timeout = t
#define easy_session_set_request(s, p, t, a)                \
    (s)->r.opacket = (void*) p;                             \
    (s)->r.args = (void*)a; (s)->timeout = t;

#define easy_session_packet_create(type, s, size)           \
    ((s = easy_session_create(size + sizeof(type))) ? ({    \
        memset(&((s)->data[0]), 0, sizeof(type));           \
        (s)->r.opacket = &((s)->data[0]);                   \
        (type*) &((s)->data[0]);}) : NULL)

#define easy_session_class_create(type, s, ...)             \
    ((s = easy_session_create(sizeof(type))) ? ({           \
        new(&((s)->data[0]))type(__VA_ARGS__);              \
        (s)->r.opacket = &((s)->data[0]);                   \
        (type*) &((s)->data[0]);}) : NULL)

#define easy_task_dispatch(eio, addr, task) easy_client_dispatch(eio, addr, (easy_session_t *)task)
#define easy_task_excute(eio, addr, process)                \
    {easy_task_t *t = easy_task_create(0);              \
        t->status = EASY_TASK_CONNECTION                   \
                    t->process = process;                              \
        easy_task_dispatch(eio, addr, t)}while(0)

#define easy_task_packet_create(type, t, size)              \
    ((t = easy_task_create(size + sizeof(type))) ? ({       \
        memset(&((t)->data[0]), 0, sizeof(type));           \
        (t)->r.opacket = &((t)->data[0]);                   \
        (t)->status = EASY_TASK_SEND_DATA;                  \
        (type*) &((t)->data[0]);}) : NULL)

#define easy_io_create(cnt)                         easy_eio_create(&easy_io_var, cnt)
#define easy_io_start()                             easy_eio_start(&easy_io_var)
#define easy_io_wait()                              easy_eio_wait(&easy_io_var)
#define easy_io_stop()                              easy_eio_stop(&easy_io_var)
#define easy_io_destroy()                           easy_eio_destroy(&easy_io_var)
#define easy_io_thread_loop(a)                      easy_eio_thread_loop(&easy_io_var,a)
#define easy_io_set_thread_cb(cb1,cb2,d)            easy_eio_set_thread_cb(&easy_io_var,cb1,cb2,d)
#define easy_io_connect(addr,handler,t,args)        easy_connection_connect(&easy_io_var,addr,handler,t,args,0)
#define easy_io_connect_thread(addr,h,t,args)       easy_connection_connect_thread(&easy_io_var,addr,h,t,args,0)
#define easy_io_disconnect(addr)                    easy_connection_disconnect(&easy_io_var,addr)
#define easy_io_disconnect_all(idx)                 easy_connection_disconnect_all(&easy_io_var,idx)
#define easy_io_disconnect_thread(addr)             easy_connection_disconnect_thread(&easy_io_var,addr)
#define easy_io_disconnect_direct(addr)             easy_connection_disconnect_direct(&easy_io_var, addr)
#define easy_io_disconnect_direct_thread(addr)      easy_connection_disconnect_direct_thread(&easy_io_var, addr)
#define easy_slightssl_set_peerkey_type(type)       SLIGHT_SSL_GLOBAL_set_peerkey_type(type)

// 变量
extern easy_io_t        easy_io_var;
extern pthread_key_t    easy_baseth_self_key;
extern uint8_t          easy_baseth_self_init;
#define easy_baseth_self ((easy_baseth_t *)((easy_baseth_self_init)?pthread_getspecific(easy_baseth_self_key):0))

EASY_CPP_END

#endif
