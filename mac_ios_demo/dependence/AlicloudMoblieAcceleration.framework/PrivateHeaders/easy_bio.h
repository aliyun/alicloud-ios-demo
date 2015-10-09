#include "easy_port.h"
#ifdef HAVE_LIBSLIGHTSSL
#ifndef EASY_BIO_H_
#define EASY_BIO_H_

#include "easy_define.h"
#include "easy_io_struct.h"

/*
 * # bio协议
 * 
 * 概述:
 *  在所有数据包前面，加上包含类型和长度的2字节包头。
 *  使得可以发送总长度为4字节的ping包
 * 
 * 数据结构:
 *  bio包头：
 *     {//2字节
 *         uint8_t             type : 4;
 *         uint32_t            length : 12;
 *     };
 *  ping:
 *     {//4字节
 *         uint8_t             type : 4;
 *         uint32_t            length : 12;//固定为2
 *         uint16_t            ping_id; //client发给server的为奇数，反之为偶数
 *     }
 * 当type为0xF时，为ping包
 * 当type为0x0时，为数据包
 */

EASY_CPP_START

/*
 * 替换ssl里面的read/write函数
 * 其中method指向的内存空间需要调用方来管理, 确保生命周期比ssl对象长
 * read/write为空则不替换对应函数
 */
int easy_bio_init(easy_connection_t *c);
/*
 * 直接写ping
 * @return
 *  EASY_OK 写成功
 *  EASY_AGAIN 还需要写
 *  EASY_ERROR 写失败, 可取errno
 */
int easy_bio_write_ping(easy_connection_t *c);

int easy_bio_ping(easy_io_t *eio, easy_addr_t addr);

void easy_bio_new(easy_connection_t *c);

/*
 * 0 不需要发ping
 * 非0 需要发ping
 */
int easy_bio_want_ping(easy_connection_t *c);

EASY_CPP_END
#endif
#endif
