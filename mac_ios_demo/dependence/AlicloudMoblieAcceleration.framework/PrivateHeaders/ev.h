/*
 * libev native API header
 *
 * Copyright (c) 2007,2008,2009,2010 Marc Alexander Lehmann <libev@schmorp.de>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modifica-
 * tion, are permitted provided that the following conditions are met:
 *
 *   1.  Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *   2.  Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MER-
 * CHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPE-
 * CIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTH-
 * ERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Alternatively, the contents of this file may be used under the terms of
 * the GNU General Public License ("GPL") version 2 or any later version,
 * in which case the provisions of the GPL are applicable instead of
 * the above. If you wish to allow the use of your version of this file
 * only under the terms of the GPL and not to allow others to use your
 * version of this file under the BSD license, indicate your decision
 * by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL. If you do not delete the
 * provisions above, a recipient may use your version of this file under
 * either the BSD or the GPL.
 */

#ifndef EV_H_
#define EV_H_

#define EV_MINPRI 0
#define EV_MAXPRI 0

/*****************************************************************************/

typedef double          ev_tstamp;

#ifndef EV_ATOMIC_T
# include <signal.h>
# define EV_ATOMIC_T sig_atomic_t volatile
#endif

struct                  ev_loop;
/* eventmask, revents, events... */
enum {
    EV_UNDEF    = 0xFFFFFFFF, /* guaranteed to be invalid */
    EV_NONE     =       0x00, /* no events */
    EV_READ     =       0x01, /* ev_io detected read will not block */
    EV_WRITE    =       0x02, /* ev_io detected write will not block */
    EV__IOFDSET =       0x80, /* internal use only */
    EV_IO       =    EV_READ, /* alias for type-detection */
    EV_TIMER    = 0x00000100, /* timer timed out */
    EV_CHILD    = 0x00000800, /* child/pid had status change */
    EV_ASYNC    = 0x00080000, /* async intra-loop signal */
    EV_ERROR_    = 0x80000000  /* sent when an error occurs */
};

#ifndef EV_CB_DECLARE
# define EV_CB_DECLARE(type) void (*cb)(struct ev_loop *loop, struct type *w, int revents);
#endif
#ifndef EV_CB_INVOKE
# define EV_CB_INVOKE(watcher,revents) (watcher)->cb (loop, (watcher), (revents))
#endif

/*
 * struct member types:
 * private: you may look at them, but not change them,
 *          and they might not mean anything to you.
 * ro: can be read anytime, but only changed when the watcher isn't active.
 * rw: can be read and modified anytime, even when the watcher is active.
 *
 * some internal details that might be helpful for debugging:
 *
 * active is either 0, which means the watcher is not active,
 *           or the array index of the watcher (periodics, timers)
 *           or the array index + 1 (most other watchers)
 *           or simply 1 for watchers that aren't in some array.
 * pending is either 0, in which case the watcher isn't,
 *           or the array index + 1 in the pendings array.
 */

/* shared by all watchers */
#define EV_WATCHER(type)            \
    int                     active; /* private */         \
    int                     pending; /* private */            \
    void                    *data;  /* rw */                \
    EV_CB_DECLARE (type) /* private */

#define EV_WATCHER_LIST(type)           \
    EV_WATCHER (type)             \
    struct ev_watcher_list  *next; /* private */

#define EV_WATCHER_TIME(type)           \
    EV_WATCHER (type)             \
    ev_tstamp               at;     /* private */

/* base class, nothing to see here unless you subclass */
typedef struct ev_watcher {
    EV_WATCHER (ev_watcher)
} ev_watcher;

/* base class, nothing to see here unless you subclass */
typedef struct ev_watcher_list {
    EV_WATCHER_LIST (ev_watcher_list)
} ev_watcher_list;

/* base class, nothing to see here unless you subclass */
typedef struct ev_watcher_time {
    EV_WATCHER_TIME (ev_watcher_time)
} ev_watcher_time;

/* invoked when fd is either EV_READable or EV_WRITEable */
/* revent EV_READ, EV_WRITE */
typedef struct ev_io {
    EV_WATCHER_LIST (ev_io)

    int                     fd;     /* ro */
    int                     events; /* ro */
} ev_io;

/* invoked after a specific time, repeatable (based on monotonic clock) */
/* revent EV_TIMEOUT */
typedef struct ev_timer {
    EV_WATCHER_TIME (ev_timer)

    ev_tstamp               repeat; /* rw */
} ev_timer;

/* invoked for each run of the mainloop, just before the blocking call */
/* you can still change events in any way you like */
/* revent EV_PREPARE */
typedef struct ev_prepare {
    EV_WATCHER (ev_prepare)
} ev_prepare;

/* invoked when somebody calls ev_async_send on the watcher */
/* revent EV_ASYNC */
typedef struct ev_async {
    EV_WATCHER (ev_async)

    EV_ATOMIC_T             sent; /* private */
} ev_async;
# define ev_async_pending(w) (+(w)->sent)

/* the presence of this union forces similar struct layout */
union ev_any_watcher {
    struct ev_watcher       w;
    struct ev_watcher_list  wl;

    struct ev_io            io;
    struct ev_timer         timer;
    struct ev_prepare       prepare;
    struct ev_async         async;
};

/* method bits to be ored together */
enum {
    EVBACKEND_SELECT  = 0x00000001U, /* about anywhere */
    EVBACKEND_KQUEUE  = 0x00000008U, /* bsd */
    EVBACKEND_ALL     = 0x0000003FU
};

ev_tstamp ev_time (void);

/* Sets the allocation function to use, works like realloc.
 * It is used to allocate and free memory.
 * If it returns zero when memory needs to be allocated, the library might abort
 * or take some potentially destructive action.
 * The default is your system realloc function.
 */
void ev_set_allocator (void *(*cb)(void *ptr, size_t size));

/* set the callback function to call on a
 * retryable syscall error
 * (such as failed select, poll, epoll_wait)
 */
void ev_set_syserr_cb (void (*cb)(const char *msg));

/* create and destroy alternative loops that don't handle signals */
struct ev_loop *ev_loop_new (unsigned int flags);

ev_tstamp ev_now (struct ev_loop *loop); /* time w.r.t. timers and the eventloop, updated after each poll */

/* destroy event loops, also works for the default loop */
void ev_loop_destroy (struct ev_loop *loop);

unsigned int ev_backend (struct ev_loop *loop); /* backend in use by loop */

void ev_now_update (struct ev_loop *loop); /* update event loop time */

/* ev_run flags values */
enum {
    EVRUN_NOWAIT = 1, /* do not block/wait */
    EVRUN_ONCE   = 2  /* block *once* only */
};

/* ev_break how values */
enum {
    EVBREAK_CANCEL = 0, /* undo unloop */
    EVBREAK_ONE    = 1, /* unloop once */
    EVBREAK_ALL    = 2  /* unloop all loops */
};

void ev_run (struct ev_loop *loop, int flags);
void ev_break (struct ev_loop *loop, int how); /* break out of the loop */

/*
 * ref/unref can be used to add or remove a refcount on the mainloop. every watcher
 * keeps one reference. if you have a long-running watcher you never unregister that
 * should not keep ev_loop from running, unref() after starting, and ref() before stopping.
 */
void ev_ref   (struct ev_loop *loop);
void ev_unref (struct ev_loop *loop);

void ev_invoke_pending (struct ev_loop *loop); /* invoke all pending watchers */
void ev_set_userdata (struct ev_loop *loop, void *data);
void *ev_userdata (struct ev_loop *loop);
void ev_set_invoke_pending_cb (struct ev_loop *loop, void (*invoke_pending_cb)(struct ev_loop *loop));

/* these may evaluate ev multiple times, and the other arguments at most once */
/* either use ev_init + ev_TYPE_set, or the ev_TYPE_init macro, below, to first initialise a watcher */
#define ev_init(ev,cb_) do {            \
        ((ev_watcher *)(void *)(ev))->active  =   \
                ((ev_watcher *)(void *)(ev))->pending = 0;    \
        ev_set_cb ((ev), cb_);            \
    } while (0)

#define ev_io_set(ev,fd_,events_)            do { (ev)->fd = (fd_); (ev)->events = (events_) | EV__IOFDSET; } while (0)
#define ev_timer_set(ev,after_,repeat_)      do { (ev)->at = (after_); (ev)->repeat = (repeat_); } while (0)
#define ev_prepare_set(ev)                   /* nop, yes, this is a serious in-joke */
#define ev_async_set(ev)                     /* nop, yes, this is a serious in-joke */

#define ev_io_init(ev,cb,fd,events)          do { ev_init ((ev), (cb)); ev_io_set ((ev),(fd),(events)); } while (0)
#define ev_timer_init(ev,cb,after,repeat)    do { ev_init ((ev), (cb)); ev_timer_set ((ev),(after),(repeat)); } while (0)
#define ev_prepare_init(ev,cb)               do { ev_init ((ev), (cb)); ev_prepare_set ((ev)); } while (0)
#define ev_async_init(ev,cb)                 do { ev_init ((ev), (cb)); ev_async_set ((ev)); } while (0)

#define ev_is_pending(ev)                    (0 + ((ev_watcher *)(void *)(ev))->pending) /* ro, true when watcher is waiting for callback invocation */
#define ev_is_active(ev)                     (0 + ((ev_watcher *)(void *)(ev))->active) /* ro, true when the watcher has been started */

#define ev_cb(ev)                            (ev)->cb /* rw */
#define ev_set_cb(ev,cb_)                   ev_cb (ev) = (cb_)

/* stopping (enabling, adding) a watcher does nothing if it is already running */
/* stopping (disabling, deleting) a watcher does nothing unless its already running */

/* feeds an event into a watcher as if the event actually occured */
/* accepts any ev_watcher type */
void ev_feed_event     (struct ev_loop *loop, void *w, int revents);
void ev_feed_fd_event  (struct ev_loop *loop, int fd, int revents);
void ev_invoke         (struct ev_loop *loop, void *w, int revents);
int  ev_clear_pending  (struct ev_loop *loop, void *w);

void ev_io_start       (struct ev_loop *loop, ev_io *w);
void ev_io_stop        (struct ev_loop *loop, ev_io *w);

void ev_timer_start    (struct ev_loop *loop, ev_timer *w);
void ev_timer_stop     (struct ev_loop *loop, ev_timer *w);
/* stops if active and no repeat, restarts if active and repeating, starts if inactive and repeating */
void ev_timer_again    (struct ev_loop *loop, ev_timer *w);

void ev_async_start    (struct ev_loop *loop, ev_async *w);
void ev_async_stop     (struct ev_loop *loop, ev_async *w);
void ev_async_send     (struct ev_loop *loop, ev_async *w);
void ev_async_fsend    (struct ev_loop *loop, ev_async *w);

typedef struct ev_loop  ev_loop;

#endif

