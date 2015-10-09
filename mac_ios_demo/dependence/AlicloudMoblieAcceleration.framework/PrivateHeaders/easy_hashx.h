#ifndef EASY_HASHX_H_
#define EASY_HASHX_H_

/**
 * 固定HASH桶的hashtable, 需要在使用的对象上定义一个easy_hashx_list_t
 */
#include "easy_list.h"
#include "easy_buf.h"
#include "easy_hash.h"

EASY_CPP_START
#define LOAD_FACTOR 0.75

typedef struct easy_hashx_t easy_hashx_t;
typedef struct easy_hashx_list_t easy_hashx_list_t;
typedef struct easy_hashx_node_t easy_hashx_node_t;
typedef int (easy_hashx_cmp_pt)(const void *a, const void *b);

struct easy_hashx_t {
    uint32_t                size;
    uint32_t                mask;
    uint32_t                count;
    int16_t                 offset;
    easy_hashx_node_t       **buckets;
};

struct easy_hashx_node_t {
    easy_hashx_node_t *next;
    easy_hashx_node_t **pprev;
    uint64_t         key;
};

#define easy_hashx_for_each_safe(i, node, n, table)                  \
    for(i=0; i<table->size; i++)                                        \
        for(node = table->buckets[i]; node && ({ n = node->next; 1; }); node = n)


#define easy_hashx_for_each(i, node, table)                             \
    for(i=0; i<table->size; i++)                                        \
        for(node = table->buckets[i]; node; node = node->next)

#define easy_hashx_entry(table, node)                                   \
    ((char *)node - table->offset)

extern easy_hashx_t *easy_hashx_create(uint32_t size, int offset);
extern int easy_hashx_add(easy_hashx_t *table, uint64_t key, easy_hashx_node_t *node);
extern inline void _easy_hashx_add(easy_hashx_t *table, uint64_t key, easy_hashx_node_t *node);
extern void *easy_hashx_find(easy_hashx_t *table, uint64_t key);
extern int easy_hashx_resize(easy_hashx_t *table);
void *easy_hashx_find_ex(easy_hashx_t *table, uint64_t key, easy_hashx_cmp_pt cmp, const void *a);
extern void easy_hashx_clear(easy_hashx_t *table);
extern void *easy_hashx_del(easy_hashx_t *table, uint64_t key);
extern int easy_hashx_del_node(easy_hashx_node_t *n);
extern void easy_hashx_free(easy_hashx_t *table);
extern void easy_hashx_destroy(easy_hashx_t *table);

EASY_CPP_END

#endif
