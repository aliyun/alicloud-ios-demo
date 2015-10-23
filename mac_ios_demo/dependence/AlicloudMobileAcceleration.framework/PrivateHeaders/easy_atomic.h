#ifndef EASY_LOCK_ATOMIC_H_
#define EASY_LOCK_ATOMIC_H_

#include "easy_define.h"
#include <stdint.h>
#include <sched.h>
#include <pthread.h>

/**
 * 原子操作
 */

EASY_CPP_START

#define easy_atomic_set(v,i)        ((v) = (i))

typedef volatile intptr_t           easy_atomic_t;
typedef volatile int32_t            easy_atomic32_t;

#define easy_atomic32_add(value, diff) ((void)__sync_add_and_fetch(value, diff))
#define easy_atomic32_add_return(value, diff) __sync_add_and_fetch(value, diff)
#define easy_atomic32_inc(value) ((void)__sync_add_and_fetch(value, 1))
#define easy_atomic32_dec(value) ((void)__sync_add_and_fetch(value, -1))

#define easy_atomic_add(value, diff) ((void)__sync_add_and_fetch(value, diff))
#define easy_atomic_add_return(value, diff) __sync_add_and_fetch(value, diff)
#define easy_atomic_inc(value) ((void)__sync_add_and_fetch(value, 1))
#define easy_atomic_dec(value) ((void)__sync_add_and_fetch(value, -1))

/*
 * easy_spin_t    lock = EASY_SPIN_INITIALIZER;
 * easy_spin_init(&lock);
 * easy_spin_lock(&lock);
 * easy_spin_unlock(&lock);
 * easy_spin_trylock(&lock);
 * easy_spin_destroy(&lock);
 */

#define easy_spin_t                   pthread_mutex_t
#define easy_spin_init(l)             pthread_mutex_init(l, NULL)
#define easy_spin_lock                pthread_mutex_lock
#define easy_spin_unlock              pthread_mutex_unlock
#define easy_spin_trylock(l)          (pthread_mutex_trylock(l) == 0)
#define easy_trylock                  easy_spin_trylock
#define easy_unlock                   easy_spin_unlock
#define easy_spin_destroy             pthread_mutex_destroy
#define EASY_SPIN_INITIALIZER         PTHREAD_MUTEX_INITIALIZER 

/*
 * hard memory barrier
 * 调用后确保对内存的读写已落地
 */
#define easy_full_barrier() (__sync_synchronize())
/*
 * 阻止编译器对指令顺序优化
 */
#define easy_compile_barrier() __asm__ __volatile__("" : : : "memory")

/*
 * 使用easy_ls_barrier在各构架上确保数据读写已落地
 */
#if defined(__i386) || defined(__x86_64__)
/* All loads are acquire loads and all stores are release stores.  */
#define easy_ls_barrier() easy_compile_barrier()
#else
#define easy_ls_barrier() easy_full_barrier()
#endif

EASY_CPP_END

#endif
