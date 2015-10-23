#include "easy_compat_end.h"

/**
 *
 * 用来兼容slightssl v1和v2
 * 将slightssl的接口，加上v1后缀
 *
 */

#undef SLIGHT_SSL_client_method

#define SLIGHT_SSL_CTX                  SLIGHT_SSL_CTX_v1
#define SLIGHT_SSL_CTX_new              SLIGHT_SSL_CTX_new_v1
#define SLIGHT_SSL_client_method        SLIGHT_SSL_client_method_v1
#define SLIGHT_SSL_CTX_set_version      SLIGHT_SSL_CTX_set_version_v1
#define SLIGHT_SSL_CTX_free             SLIGHT_SSL_CTX_free_v1
#define SLIGHT_SSL_set_usercontext      SLIGHT_SSL_set_usercontext_v1
#define SLIGHT_SSL_set_fd               SLIGHT_SSL_set_fd_v1
#define SLIGHT_SSL_connect              SLIGHT_SSL_connect_v1
#define SLIGHT_SSL_get_error            SLIGHT_SSL_get_error_v1
#define SLIGHT_SSL_read                 SLIGHT_SSL_read_v1
#define SLIGHT_SSL_pending              SLIGHT_SSL_pending_v1
#define SLIGHT_SSL_want_write           SLIGHT_SSL_want_write_v1
#define SLIGHT_SSL_write                SLIGHT_SSL_write_v1
#define SLIGHT_SSL_CTX_set_performance_cb SLIGHT_SSL_CTX_set_performance_cb_v1
#define SSL_ERROR_WANT_WRITE            SSL_ERROR_WANT_WRITE_v1
#define SSL_ERROR_WANT_READ             SSL_ERROR_WANT_READ_v1
#define SLIGHT_SSL                      SLIGHT_SSL_v1
#define SLIGHT_SSL_PERFORMANCE_DATA     SLIGHT_SSL_PERFORMANCE_DATA_v1
#define SLIGHT_SSL_new                  SLIGHT_SSL_new_v1
#define SLIGHT_SSL_free                 SLIGHT_SSL_free_v1
#define SLIGHT_SSL_CTX_set_cert_cb      SLIGHT_SSL_CTX_set_cert_cb_v1
#define SLIGHT_SSL_CTX_set_pubkey_cb    SLIGHT_SSL_CTX_set_pubkey_cb_v1
#define SSL_READ_END_ERR                SSL_READ_END_ERR_v1
#define SLIGHT_SSL_is_write_block       SLIGHT_SSL_is_write_block_v1
//#define ERR_READ_END                    ERR_READ_END_v1
//#define ERR_WRITE_END                   ERR_WRITE_END_v1
