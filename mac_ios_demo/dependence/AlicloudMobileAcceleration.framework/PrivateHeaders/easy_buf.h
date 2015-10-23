#ifndef EASY_BUF_H_
#define EASY_BUF_H_

/**
 * 网络的读写的BUFFER
 */
#include "easy_define.h"
#include "easy_pool.h"

EASY_CPP_START
#define EASY_BUF_START              0x05

typedef struct easy_buf_t easy_buf_t;
typedef struct easy_buf_string_t easy_buf_string_t;
typedef void (easy_buf_cleanup_pt)(easy_buf_t *, void *);

#define EASY_BUF_DEFINE                 \
    easy_list_t             node;       \
    int                     flags;      \
    easy_buf_cleanup_pt     *startup;   \
    easy_buf_cleanup_pt     *endup;     \
    easy_buf_cleanup_pt     *cleanup;   \
    int8_t                  ssl_idx;    \
    void                    *args;

struct easy_buf_t {
    EASY_BUF_DEFINE;
    char                    *pos;
    char                    *last;
    char                    *end;
};

struct easy_buf_string_t {
    char                    *data;
    int                     len;
};

extern easy_buf_t *easy_buf_calloc(uint32_t size);
extern easy_buf_t *easy_buf_create(easy_pool_t *pool, uint32_t size);
extern void easy_buf_set_cleanup(easy_buf_t *b, easy_buf_cleanup_pt *cleanup, void *args);
extern void easy_buf_set_endup(easy_buf_t *b, easy_buf_cleanup_pt *endup, void *args);
extern void easy_buf_set_data(easy_pool_t *pool, easy_buf_t *b, const void *data, uint32_t size);
extern easy_buf_t *easy_buf_pack(easy_pool_t *pool, const void *data, uint32_t size);
extern void easy_buf_destroy(easy_buf_t *b);
extern int easy_buf_check_read_space(easy_pool_t *pool, easy_buf_t *b, uint32_t size);
extern easy_buf_t *easy_buf_check_write_space(easy_pool_t *pool, easy_list_t *bc, uint32_t size);


extern void easy_buf_chain_clear(easy_list_t *l);
extern void easy_buf_chain_offer(easy_list_t *l, easy_buf_t *b);

///////////////////////////////////////////////////////////////////////////////////////////////////
// easy_buf_string

#define easy_buf_string_set(str, text) {(str)->len=strlen(text); (str)->data=(char*)text;}

static inline char *easy_buf_string_ptr(easy_buf_string_t *s)
{
    return s->data;
}

static inline void easy_buf_string_append(easy_buf_string_t *s,
        const char *value, int len)
{
    s->data = (char *)(value - s->len);
    s->len += len;
}

static inline int easy_buf_len(easy_buf_t *b)
{
    return (int)(b->last - b->pos);
}

extern int easy_buf_string_copy(easy_pool_t *pool, easy_buf_string_t *d, const easy_buf_string_t *s);
extern int easy_buf_string_printf(easy_pool_t *pool, easy_buf_string_t *d, const char *fmt, ...);
extern int easy_buf_list_len(easy_list_t *l);
extern void easy_buf_set_startup(easy_buf_t *b, easy_buf_cleanup_pt *startup, void *args);
extern void easy_buf_start(easy_buf_t *b);

#define EASY_FSTR           ".*s"
#define EASY_PSTR(a)        ((a)->len),((a)->data)
static const easy_buf_string_t easy_string_null = {(char *)"", 0};

EASY_CPP_END

#endif
