#include "easy_port.h"
#ifdef HAVE_LIBSLIGHTSSL
#ifndef EASY_SBIO_H_
#define EASY_SBIO_H_

#include "slight_ssl.h"
#include "easy_define.h"
#include "easy_io_struct.h"

EASY_CPP_START

#define EASY_BIO_HDR_SIZE 2

/*
 * 替换ssl里面的read/write函数
 * 其中method指向的内存空间需要调用方来管理, 确保生命周期比ssl对象长
 * read/write为空则不替换对应函数
 */
int easy_bio_set(SLIGHT_SSL *ssl, SSSL_BIO_READ_METHOD read_cb, SSSL_BIO_WRITE_METHOD write_cb, void *args);

ssize_t easy_bio_write_with_hdr(SSSL_BIO *b, const void *data, size_t len, int flags);
int easy_bio_read_hdr(easy_connection_t *c, easy_bio_hdr_t **hdr);
int easy_bio_read_data(easy_connection_t *c, char *data, int len);
void easy_bio_clear_hdr();
easy_bio_hdr_t * easy_bio_get_hdr();

EASY_CPP_END
#endif
#endif
