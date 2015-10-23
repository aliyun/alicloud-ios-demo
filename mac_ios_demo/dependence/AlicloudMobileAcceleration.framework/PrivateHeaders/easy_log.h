#ifndef EASY_LOG_H_
#define EASY_LOG_H_

/**
 * 简单的log输出
 */
#include "easy_define.h"
#include "easy_string.h"
#include "easy_baseth_pool.h"
#include "easy_logfile.h"


EASY_CPP_START

typedef void (*easy_log_print_pt)(int level, const char *message);
typedef void (*easy_log_format_pt)(int level, const char *file, int line, const char *function, const char *fmt, ...) __attribute__ ((__format__ (__printf__, 5, 6)));
typedef enum {
    EASY_LOG_OFF = 1,
    EASY_LOG_FATAL,
    EASY_LOG_ERROR,
    EASY_LOG_WARN,
    EASY_LOG_INFO,
    EASY_LOG_DEBUG,
    EASY_LOG_TRACE,
    EASY_LOG_ALL
} easy_log_level_t;

#define easy_log_common(file, line, format, args...)                            \
        easy_log_format_default(EASY_LOG_OFF, file, line, __FUNCTION__, format, ## args)
#define easy_fatal_log(format, args...) if(easy_log_level>=EASY_LOG_FATAL)      \
        easy_log_format(EASY_LOG_FATAL, __FILE__, __LINE__, __FUNCTION__, format, ## args)
#define easy_error_log(format, args...) if(easy_log_level>=EASY_LOG_ERROR)      \
        easy_log_format(EASY_LOG_ERROR, __FILE__, __LINE__, __FUNCTION__, format, ## args)
#define easy_warn_log(format, args...) if(easy_log_level>=EASY_LOG_WARN)        \
        easy_log_format(EASY_LOG_WARN, __FILE__, __LINE__, __FUNCTION__, format, ## args)
#define easy_info_log(format, args...) if(easy_log_level>=EASY_LOG_INFO)        \
        easy_log_format(EASY_LOG_INFO, __FILE__, __LINE__, __FUNCTION__, format, ## args)
#define easy_debug_log(format, args...) if(easy_log_level>=EASY_LOG_DEBUG)      \
        easy_log_format(EASY_LOG_DEBUG, __FILE__, __LINE__, __FUNCTION__, format, ## args)
#define easy_trace_log(format, args...) if(easy_log_level>=EASY_LOG_TRACE)      \
        easy_log_format(EASY_LOG_TRACE, __FILE__, __LINE__, __FUNCTION__, format, ## args)
/**
 * easy_syserr(0xdead10cc, 1, 2, 3, 4)
 * @note reason只能4字节，args至少1个，至多4个，才能保证平台兼容
 */
#define easy_syserr(reason, info, args...) ((void (*)(void *,...))reason)((void *)info, args)

extern easy_log_level_t easy_log_level;
extern easy_log_format_pt easy_log_format;
extern void easy_log_set_print(easy_log_print_pt p);
extern void easy_log_set_format(easy_log_format_pt p);
extern void easy_log_format_default(int level, const char *file, int line, const char *function, const char *fmt, ...) __attribute__ ((__format__ (__printf__, 5, 6)));

extern void easy_log_print_default(int level, const char *message);
extern void easy_log_print_android(int level, const char *message);
extern void easy_log_print_file_android(int level, const char *message);
extern void easy_log_print_file(int level, const char *message);
extern void easy_log_init();

EASY_CPP_END

#endif
