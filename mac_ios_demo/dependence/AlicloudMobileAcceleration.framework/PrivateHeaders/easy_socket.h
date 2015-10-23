#ifndef EASY_SOCKET_H_
#define EASY_SOCKET_H_

#include "easy_define.h"
#include "easy_io_struct.h"
#include "easy_log.h"
#include <netinet/in.h>

/**
 * socket处理
 */

EASY_CPP_START

#define EASY_FLAGS_DEFERACCEPT 0x001
#define EASY_FLAGS_REUSEPORT   0x002
#define EASY_FLAGS_SREUSEPORT  0x004
#define EASY_FLAGS_NOLISTEN    0x008
#ifndef SO_REUSEPORT
# define SO_REUSEPORT 15
#endif
int easy_socket_write(easy_connection_t *c, easy_list_t *l);
int easy_socket_read(easy_connection_t *c, char *buf, int size, int *pending);
int easy_socket_non_blocking(int fd);
int easy_socket_set_tcpopt(int fd, int option, int value);
int easy_socket_set_opt(int fd, int option, int value);
int easy_socket_support_ipv6();
int easy_socket_usend(easy_connection_t *c, easy_list_t *l);
int easy_socket_urecv(easy_connection_t *c, char *buf, int size, int *pending);
int easy_socket_error(int fd);
int easy_socket_set_linger(int fd, int t);

int easy_socket_udpwrite(int fd, struct sockaddr *addr, easy_list_t *l);
int easy_socket_tcpwrite(int fd, easy_list_t *l);
int easy_socket_get_opt(int fd, int option);
int easy_socket_get_tcpopt(int fd, int option);
int easy_is_non_blocking(int fd);
int easy_tcp_cork_on(int fd);
int easy_tcp_cork_off(int fd);

EASY_CPP_END

#endif
