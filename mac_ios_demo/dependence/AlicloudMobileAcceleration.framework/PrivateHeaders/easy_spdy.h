#ifndef EASY_ALBBMAC_H_
#define EASY_ALBBMAC_H_

#include "easy_port.h"
#include "easy_define.h"
#include "easy_log.h"
#include "easy_io_struct.h"
#include "easy_connection.h"

#define EASY_HTTP_HDR_MAX_SIZE              128

#define EASY_LENGTH_MASK                    0xffffff
#define EASY_VERSION_MASK                   0x7fff
#define EASY_STREAM_ID_MASK                 0x7fffffff
#define EASY_SETTINGS_ID_MASK               0xffffff
#define EASY_ALBBMAC_CTL_BIT                   1
#define EASY_ALBBMAC_VERSION                   3

#define EASY_ALBBMAC_DEFAULT_WINDOW_SIZE       0x10000

#define EASY_FRAME_HEAD_LENGTH              8
#define EASY_ALBBMAC_FLAG_FIN                  0x01

#define EASY_ALBBMAC_NV_BUF_SIZE               4096
#define EASY_ALBBMAC_STREAM_TABLE_SIZE         32
#define EASY_RST_STREAM_SIZE                16
#define EASY_WINDOW_UPDATE_SIZE             16
#define EASY_PING_SIZE                      12
#define EASY_SYN_STREAM_NV_OFFSET           18
#define EASY_SYN_REPLY_NV_OFFSET            12

#define EASY_ALBBMAC_STREAM_OPEN               0
#define EASY_ALBBMAC_STREAM_HALF_CLOSE         1
#define EASY_ALBBMAC_STREAM_CLOSE              2

#define EASY_ALBBMAC_BUFFER_SIZE               4096
//name/value header block里键值对数最大值
#define EASY_ALBBMAC_MAX_NAME_VALUES           4096

#define easy_is_ctrl_frame(data) ((*(char *)(data)) & 0x80)

#define easy_spdy_frame_parse_uint16(p)  ntohs(*(uint16_t *) (p))
#define easy_spdy_frame_parse_uint32(p)  ntohl(*(uint32_t *) (p))

#define easy_spdy_frame_aligned_write_uint16(p, s)                               \
    (*(uint16_t *) (p) = htons((uint16_t) (s)), (p) + sizeof(uint16_t))
#define easy_spdy_frame_aligned_write_uint32(p, s)                               \
    (*(uint32_t *) (p) = htonl((uint32_t) (s)), (p) + sizeof(uint32_t))
#define easy_spdy_frame_write_uint32(p, s)                                       \
    (*(uint32_t *) (p) = htonl((uint32_t) (s)))

#define easy_spdy_frame_parse_type(p)                                            \
    easy_spdy_frame_parse_uint16(p)
#define easy_spdy_frame_parse_version(p)                                         \
    (easy_spdy_frame_parse_uint16(p) & EASY_VERSION_MASK)
#define easy_spdy_frame_parse_sid(p)                                             \
    (easy_spdy_frame_parse_uint32(p) & EASY_STREAM_ID_MASK)
#define easy_spdy_frame_parse_pri(p)                                             \
    (*((uint8_t *)(p)) >> 5)
#define easy_spdy_frame_parse_length(p)                                          \
    (easy_spdy_frame_parse_uint32(p) & EASY_LENGTH_MASK)
#define easy_spdy_frame_parse_settings_id(p)                                     \
    (easy_spdy_frame_parse_uint32(p) & EASY_SETTINGS_ID_MASK)

#define easy_spdy_write_head_name(last, data, len) do {                          \
        last = easy_spdy_frame_aligned_write_uint32(last, len);                  \
        int i;                                                                   \
        for (i = 0; i < len; i++) {                                              \
            last[i] = (data[i] >= 'A' && data[i] <= 'Z') ? data[i] + 32: data[i];\
        }                                                                        \
        last += (len);} while(0)
#define easy_spdy_write_head_value(last, data, len) do {                         \
        last = easy_spdy_frame_aligned_write_uint32(last, len);                  \
        if (len > 0) {                                                           \
            memcpy(last, data, len);                                             \
            last += (len);                                                       \
        }                                                                        \
    } while(0)

#define easy_spdy_frame_write_pri(last, pri)                                     \
    (*(uint8_t *)(last) = (pri) << 5, (last) + 1)

#define easy_spdy_ctl_frame_head(t)                                              \
    ((uint32_t) EASY_ALBBMAC_CTL_BIT << 31 | EASY_ALBBMAC_VERSION << 16 | (t))
#define easy_spdy_frame_write_head(p, t)                                         \
    easy_spdy_frame_aligned_write_uint32(p, easy_spdy_ctl_frame_head(t))
#define easy_spdy_frame_write_flags_and_len(p, f, l)                             \
    easy_spdy_frame_aligned_write_uint32(p, (f) << 24 | (l))
#define easy_spdy_frame_write_flags_and_id(p, f, l)                             \
    easy_spdy_frame_aligned_write_uint32(p, (f) << 24 | (l))
#define easy_spdy_frame_write_sid(p, sid)                                        \
    easy_spdy_frame_aligned_write_uint32(p, sid)
#define easy_spdy_frame_write_string(p, s)                                       \
    (*(uint32_t *) (p) = htonl((uint32_t) (sizeof((s)) - 1)), memcpy((p) + 4, ((s)), sizeof((s)) - 1), ((p) + 4 + sizeof((s)) - 1))
#define easy_spdy_frame_aligned_cpy(p, s, l)                                     \
    (memcpy(p, s, l) + l)

#define easy_spdy_set_rst_stream(frame, sid, sc)                                 \
    (frame)->hd.version = EASY_ALBBMAC_VERSION;                                 \
    (frame)->hd.flags = 0;                                                   \
    (frame)->hd.type = EASY_ALBBMAC_RST_STREAM;                                 \
    (frame)->hd.length = 8;                                                  \
    (frame)->stream_id = (sid);                                              \
    (frame)->status_code = (-(sc) - 0x10);

#define easy_spdy_set_goaway(frame, sid, sc)                                     \
    (frame)->hd.version = EASY_ALBBMAC_VERSION;                                 \
    (frame)->hd.flags = 0;                                                   \
    (frame)->hd.type = EASY_ALBBMAC_GOAWAY;                                     \
    (frame)->hd.length = 8;                                                  \
    (frame)->last_good_stream_id = (sid);                                              \
    (frame)->status_code = (-(sc) - 0x1b);

#define easy_spdy_reason(status_code)   (-(status_code)-0x10)

typedef struct easy_spdy_ctrl_hd_t easy_spdy_ctrl_hd_t;
typedef struct easy_spdy_syn_stream_t easy_spdy_syn_stream_t;
typedef struct easy_spdy_syn_reply_t easy_spdy_syn_reply_t;
typedef struct easy_spdy_rst_stream_t easy_spdy_rst_stream_t;
typedef struct easy_spdy_goaway_t easy_spdy_goaway_t;
typedef struct easy_spdy_data_t easy_spdy_data_t;
typedef struct easy_spdy_settings_entry_t easy_spdy_settings_entry_t;
typedef struct easy_spdy_settings_t easy_spdy_settings_t;
typedef struct easy_spdy_window_update_t easy_spdy_window_update_t;
typedef struct easy_spdy_ping_t easy_spdy_ping_t;
typedef struct easy_spdy_packet_ping_t easy_spdy_packet_ping_t;

typedef struct easy_spdy_stream_t easy_spdy_stream_t;

struct easy_spdy_packet_ping_t {
    uint8_t                 kind;
};

struct easy_spdy_ctrl_hd_t {
    uint8_t                 kind;
    uint16_t                version;
    uint16_t                type;
    uint8_t                 flags;
    int32_t                 length : 24;
};

struct easy_spdy_syn_stream_t {
    easy_spdy_ctrl_hd_t     hd;
    int32_t                 stream_id;
    int32_t                 assoc_stream_id;
    uint8_t                 pri;
    uint8_t                 slot;
    easy_hash_string_t      *nv;
};

struct easy_spdy_syn_reply_t {
    easy_spdy_ctrl_hd_t     hd;
    int32_t                 stream_id;
    easy_hash_string_t      *nv;
};

struct easy_spdy_rst_stream_t {
    easy_spdy_ctrl_hd_t     hd;
    int32_t                 stream_id;
    uint32_t                status_code;
};

struct easy_spdy_goaway_t {
    easy_spdy_ctrl_hd_t     hd;
    int32_t                 last_good_stream_id;
    uint32_t                status_code;
};

struct easy_spdy_settings_entry_t {
    int32_t                 settings_id;
    uint8_t                 flags;
    uint32_t                value;
};

struct easy_spdy_settings_t {
    easy_spdy_ctrl_hd_t     hd;
    int32_t                 number;
    easy_spdy_settings_entry_t  *iv;
};

struct easy_spdy_window_update_t {
    easy_spdy_ctrl_hd_t     hd;
    int32_t                 stream_id;
    int32_t                 delta_window_size;
};

struct easy_spdy_ping_t {
    easy_spdy_ctrl_hd_t     hd;
    uint32_t                ping_id;
};

struct easy_spdy_data_t {
    uint8_t                 kind;
    int32_t                 stream_id;
    uint8_t                 flags;
    int32_t                 length : 24;//可以为0
    char                    *data;
};

struct easy_spdy_stream_t {
    int32_t                 stream_id;
    int32_t                 assoc_stream_id;
    uint8_t                 pri;
    uint8_t                 slot;
    uint8_t                 status;
    int32_t                 send_window_size;
    int32_t                 recv_window_size;
    easy_http_request_t     hr;
    easy_request_t          *r;
    easy_hash_string_t      *nv;
    easy_connection_t       *c;
    easy_pool_t             *pool;
    easy_hashx_node_t       node;
    easy_session_t          *s;
    z_stream                *zst_in;
    easy_list_t             output;
    char                    buffer[EASY_ALBBMAC_BUFFER_SIZE];
};

typedef enum {
    EASY_ALBBMAC_SETTINGS_UPLOAD_BANDWIDTH =               1,
    EASY_ALBBMAC_SETTINGS_DOWNLOAD_BANDWIDTH =             2,
    EASY_ALBBMAC_SETTINGS_ROUND_TRIP_TIME =                3,
    EASY_ALBBMAC_SETTINGS_MAX_CONCURRENT_STREAMS =         4,
    EASY_ALBBMAC_SETTINGS_CURRENT_CWND =                   5,
    EASY_ALBBMAC_SETTINGS_DOWNLOAD_RETRANS_RATE =          6,
    EASY_ALBBMAC_SETTINGS_INITIAL_WINDOW_SIZE =            7,
    EASY_ALBBMAC_SETTINGS_CLIENT_CERTIFICATE_VECTOR_SIZE = 8,
} easy_spdy_settings_id_t;

typedef enum {
    EASY_ALBBMAC_ID_FLAG_SETTINGS_NONE =                     0,
    EASY_ALBBMAC_ID_FLAG_SETTINGS_PERSIST_VALUE =            1,
    EASY_ALBBMAC_ID_FLAG_SETTINGS_PERSISTED =                2
} easy_spdy_settings_flags_t;

typedef enum {
    EASY_ALBBMAC_SYN_STREAM =     1,
    EASY_ALBBMAC_SYN_REPLY =      2,
    EASY_ALBBMAC_RST_STREAM =     3,
    EASY_ALBBMAC_SETTINGS =       4,
    EASY_ALBBMAC_NOOP =           5,
    EASY_ALBBMAC_PING =           6,
    EASY_ALBBMAC_GOAWAY =         7,
    EASY_ALBBMAC_HEADERS =        8,
    EASY_ALBBMAC_WINDOW_UPDATE =  9,
    EASY_ALBBMAC_CREDENTIAL =     10
} easy_spdy_ctrl_frame_type_t;

typedef enum {
    EASY_ALBBMAC_HTTP_DATA          = 0,
    EASY_ALBBMAC_FRAME_CTL          = 1,
    EASY_ALBBMAC_FRAME_DATA         = 2,
    EASY_ALBBMAC_FRAME_INTERNAL_CTL = 3,
    EASY_ALBBMAC_FRAME_PING         = 4,
    EASY_ALBBMAC_FRAME_RST_STREAM   = 5,
} easy_spdy_packet_kind_t;

typedef enum {
    EASY_SETTINGS_UPLOAD_BANDWIDTH               = 1,
    EASY_SETTINGS_DOWNLOAD_BANDWIDTH             = 2,
    EASY_SETTINGS_ROUND_TRIP_TIME                = 3,
    EASY_SETTINGS_MAX_CONCURRENT_STREAMS         = 4,
    EASY_SETTINGS_CURRENT_CWND                   = 5,
    EASY_SETTINGS_DOWNLOAD_RETRANS_RATE          = 6,
    EASY_SETTINGS_INITIAL_WINDOW_SIZE            = 7,
    EASY_SETTINGS_CLIENT_CERTIFICATE_VECTOR_SIZE = 8,
} easy_spdy_settings_id;

//frame union
typedef union {
    easy_spdy_ctrl_hd_t         ctrl;
    easy_spdy_syn_stream_t      syn_stream;
    easy_spdy_syn_reply_t       syn_reply;
    easy_spdy_rst_stream_t      rst_stream;
    easy_spdy_goaway_t          goaway;
    easy_spdy_data_t            data;
    easy_spdy_settings_t        settings;
    easy_spdy_window_update_t   window_update;
    easy_spdy_ping_t            ping;
} easy_spdy_frame_t;

enum http_method {
    HTTP_DELETE    = 0
    , HTTP_GET
    , HTTP_HEAD
    , HTTP_POST
    , HTTP_PUT
    , HTTP_PURGE
    /* pathological */
    , HTTP_CONNECT
    , HTTP_OPTIONS
    , HTTP_TRACE
    /* webdav */
    , HTTP_COPY
    , HTTP_LOCK
    , HTTP_MKCOL
    , HTTP_MOVE
    , HTTP_PROPFIND
    , HTTP_PROPPATCH
    , HTTP_UNLOCK
    /* subversion */
    , HTTP_REPORT
    , HTTP_MKACTIVITY
    , HTTP_CHECKOUT
    , HTTP_MERGE
    /* upnp */
    , HTTP_MSEARCH
    , HTTP_NOTIFY
    , HTTP_SUBSCRIBE
    , HTTP_UNSUBSCRIBE
};

int easy_spdy_init(easy_connection_t *c);
void easy_spdy_destroy(easy_connection_t *c);
int easy_spdy_do_reply(easy_request_t *r);
void easy_spdy_set_process(easy_session_t *s);
int easy_spdy_on_send_frame(easy_task_t *t, easy_connection_t *c);
easy_buf_t *easy_spdy_encode_ctrl_frame(easy_pool_t *pool, uint16_t type, uint8_t flags, int32_t length, char *data);
easy_hash_string_t *easy_header_create_table(easy_pool_t *pool);
void easy_http_add_header(easy_pool_t *pool, easy_hash_string_t *table,
                          const char *name, const char *value);
char *easy_http_del_header(easy_hash_string_t *table, const char *name);
char *easy_http_get_header(easy_hash_string_t *table, const char *name);
#endif
