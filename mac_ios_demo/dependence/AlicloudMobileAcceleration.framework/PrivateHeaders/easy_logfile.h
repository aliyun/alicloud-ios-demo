#ifndef EASY_LOGFILE_H
#define EASY_LOGFILE_H

#ifdef DEBUG_LOG_FILE

#include "easy_atomic.h"
#include "easy_log_buffer.h"
#include <stdint.h>
#include <string.h>
#include <pthread.h>

#define LOG_FILE_LOG_LEN_LIMIT  1024
#define LOG_FILE_PATH_LEN_LIMIT 256
#define LOG_FILE_PATH_POST_LEN  13 // _yyyymmdd.log
#define LOG_FILE_DIR_LEN_LIMIT  (LOG_FILE_PATH_LEN_LIMIT - LOG_FILE_PATH_POST_LEN)
#define LOG_FILE_MIN_SIZE       1024

enum log_file_flush_reason_t {
    FR_FULL = 0,
    FR_TIMEOUT,
};

typedef struct log_file_t {
    // config
    int file_size;    // the limit size of a file
    int file_num;     // the limit number of files
    char* file_path;  // dir + prename

    // status
    volatile int isinit;
    volatile int close_wait;
    uint64_t timeout_us;
    long time_wait_us;
    long time_wait_delta;
    enum log_file_flush_reason_t last_reason;

    // buffer
    LOG_BUFFER buffer;

    // file
    FILE* fp;
    int date_year;
    int date_mon;
    int date_day;
    int file_index;
    char **file_name_list;
    char *_file_name_list_addr;

    // pthread
    pthread_t loop_thread;
}LOG_FILE;

extern LOG_FILE log_file;

int log_file_init(LOG_FILE* lf,
                  const char* path,
                  int size,
                  int filenum,
                  unsigned long bufsize);   // return: 0 - success, -1 - failed, -2 - re-init
void log_file_free(LOG_FILE* lf);
int log_file_print_msg(LOG_FILE* lf, const char *message, unsigned long len);
void log_file_flush(LOG_FILE* lf);

#define log_file_is_init(lf) ((lf)->isinit)

#define log_file_printf(lf, args...) do { \
    char msg[LOG_FILE_LOG_LEN_LIMIT]; \
    snprintf(msg, sizeof(msg), ## args); \
    log_file_print_msg(lf, msg, strlen(msg)); \
} while(0)

#endif

#endif

