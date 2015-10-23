#ifndef EASY_LOG_BUFFER
#define EASY_LOG_BUFFER

typedef struct log_buffer_t
{
    volatile unsigned long head;
    volatile unsigned long tail;
    volatile unsigned long size;
    char *data;
}LOG_BUFFER;

int log_buffer_init(LOG_BUFFER* lb, unsigned long size);
void log_buffer_free(LOG_BUFFER* lb);
unsigned long log_buffer_read(LOG_BUFFER* lb, char *buffer, unsigned long buffersize);
unsigned long log_buffer_write(LOG_BUFFER* lb, const char *buffer, unsigned long len);
unsigned long log_buffer_get_len(LOG_BUFFER* lb);
void log_buffer_get_len2(LOG_BUFFER* lb, unsigned long* len1, unsigned long* len2);
unsigned long log_buffer_get_space_len(LOG_BUFFER* lb);
int log_buffer_empty(LOG_BUFFER* lb);
int log_buffer_full(LOG_BUFFER* lb, unsigned long len);

#endif
