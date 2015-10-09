/*
 * libev select fd activity backend
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
#include "easy_port.h"

#include <sys/select.h>
#include <inttypes.h>
#define NFDBYTES (NFDBITS / 8)

#include <string.h>

#ifndef PLATFORM_PC
// For Android platform
typedef int fd_mask;
#endif

static void
select_modify (struct ev_loop *loop, int fd, int oev, int nev)
{
    if (oev == nev)
        return;

    {
        int                     word = fd / NFDBITS;
        fd_mask                 mask = 1UL << (fd % NFDBITS);

        if (expect_false (loop->vec_max <= word)) {
            int                     new_max = word + 1;

            loop->vec_ri = ev_realloc (loop->vec_ri, new_max * NFDBYTES);
            loop->vec_ro = ev_realloc (loop->vec_ro, new_max * NFDBYTES); /* could free/malloc */
            loop->vec_wi = ev_realloc (loop->vec_wi, new_max * NFDBYTES);
            loop->vec_wo = ev_realloc (loop->vec_wo, new_max * NFDBYTES); /* could free/malloc */

            for (; loop->vec_max < new_max; ++loop->vec_max)
                ((fd_mask *)loop->vec_ri) [loop->vec_max] =
                    ((fd_mask *)loop->vec_wi) [loop->vec_max] = 0;
        }

        ((fd_mask *)loop->vec_ri) [word] |= mask;

        if (!(nev & EV_READ))
            ((fd_mask *)loop->vec_ri) [word] &= ~mask;

        ((fd_mask *)loop->vec_wi) [word] |= mask;

        if (!(nev & EV_WRITE))
            ((fd_mask *)loop->vec_wi) [word] &= ~mask;
    }
}

#define easy_syserr(reason, info, args...) do{((void (*)(void *,...))reason)((void *)info, args);abort();}while(0)

static void
select_poll (struct ev_loop *loop, ev_tstamp timeout)
{
    struct timeval          tv;
    int                     res;
    int                     fd_setsize;
    char                    buf[1024];

    EV_RELEASE_CB;
    EV_TV_SET (tv, timeout);

    fd_setsize = loop->vec_max * NFDBYTES;

    memcpy (loop->vec_ro, loop->vec_ri, fd_setsize);
    memcpy (loop->vec_wo, loop->vec_wi, fd_setsize);

    res = select (loop->vec_max * NFDBITS, (fd_set *)loop->vec_ro, (fd_set *)loop->vec_wo, 0, &tv);
    int ret = res;
    int errno_saved = errno; //刚select出来，就把errno保存一下，避免是因为被覆盖
    EV_ACQUIRE_CB;

    if (expect_false (res < 0)) {
        if (errno == EINTR) {
        } else if (errno == EBADF)
            fd_ebadf (loop);
        else if (errno == ENOMEM) {
            fd_enomem (loop);
            snprintf(buf, 1024, "[select debug] (libev) select fail ENOMEM");
            ev_syserr(buf);
        } else if (errno == EINVAL) {
            snprintf(buf, 1024,
                "[select debug] (libev) select fail EINVAL. res=%d, e=%d, vec_mac=%d, NFDBITS=%"Psize_t", timeout=%f, sec=%ld, usec=%ld\n",
                                        res, errno, loop->vec_max, NFDBITS, timeout, tv.tv_sec, tv.tv_usec);
            ev_syserr(buf);
            abort();
        } else {
            int fail = 0;
            int errno_error = errno; //错误的errno保存一下，可以对比下，是否因为没有flush
            __sync_synchronize();
            int errno_flushed = errno; //flush后的errno
            if (!(errno == errno_saved && errno == errno_error && errno == errno_flushed)) {
                fail ++;
            }
            {
                //记录状态 判断EINVAL
                snprintf(buf, 1024,
                "[select debug] (libev) select fail. res=%d, ret=%d, e=%d, e_saved=%d, e_error=%d, e_flushed=%d, vec_mac=%d, NFDBITS=%"Psize_t", timeout=%f, sec=%ld, usec=%ld\n",
                                        res, ret, errno, errno_saved, errno_error, errno_flushed, loop->vec_max, NFDBITS, timeout, tv.tv_sec, tv.tv_usec);

                ev_syserr(buf);
            }
            {
                //判断下errno是不是实际上是EBADF
                int     fd;
                int     cnt = 20; //最多上报20个有问题的fd
                for (fd = loop->anfdmax - 1; fd >= 0 && cnt > 0; fd--) { //fd越大，猜测出错可能性越大
                    if (loop->anfds [fd].events) {
                        if (!fd_valid (fd) && errno == EBADF) {
                            snprintf(buf, 1024, "[select debug] EBADF detected: fd=%d\n", fd);
                            ev_syserr(buf);
                            cnt --;
                            fail ++;
                        }
                    }
                }
                snprintf(buf, 1024, "[select debug] %d fds got, anfdmax %d\n", 20 - cnt, loop->anfdmax);
                ev_syserr(buf);
            }
            {
                //判断下是不是ENOMEM 
                void *p = NULL;
                if ((p = malloc(128)) == NULL) {
                    snprintf(buf, 1024,
                    "[select debug] malloc 128 fail p=%p\n", p);
                    fail ++;
                } else {
                    snprintf(buf, 1024,
                    "[select debug] malloc 128 succ p=%p\n", p);
                    free(p);
                }
                ev_syserr(buf);
                if ((p = malloc(512)) == NULL) {
                    snprintf(buf, 1024,
                    "[select debug] malloc 512 fail p=%p\n", p);
                    fail ++;
                } else {
                    snprintf(buf, 1024,
                    "[select debug] malloc 512 succ p=%p\n", p);
                    free(p);
                }
                ev_syserr(buf);
                if ((p = malloc(4096)) == NULL) {
                    snprintf(buf, 1024,
                    "[select debug] malloc 4096 fail p=%p\n", p);
                    fail ++;
                } else {
                    snprintf(buf, 1024,
                    "[select debug] malloc 4096 succ p=%p\n", p);
                    free(p);
                }
                ev_syserr(buf);
            }
            if (fail) {
                easy_syserr(0xf0cc0a11, 0xdead, errno_saved, errno_error, errno_flushed);
            }
        }

        return;
    }

    {
        int                     word, bit;

        for (word = loop->vec_max; word--; ) {
            fd_mask                 word_r = ((fd_mask *)loop->vec_ro) [word];
            fd_mask                 word_w = ((fd_mask *)loop->vec_wo) [word];

            if (word_r || word_w)
                for (bit = NFDBITS; bit--; ) {
                    fd_mask                 mask = 1UL << bit;
                    int                     events = 0;

                    events |= word_r & mask ? EV_READ  : 0;
                    events |= word_w & mask ? EV_WRITE : 0;

                    if (expect_true (events))
                        fd_event (loop, word * NFDBITS + bit, events);
                }
        }
    }
}

#undef easy_syserr

int inline_size
select_init (struct ev_loop *loop, int flags)
{
    loop->backend_modify = select_modify;
    loop->backend_poll   = select_poll;

    loop->vec_max = 0;
    loop->vec_ri  = 0;
    loop->vec_ro  = 0;
    loop->vec_wi  = 0;
    loop->vec_wo  = 0;

    return EVBACKEND_SELECT;
}

void inline_size
select_destroy (struct ev_loop *loop)
{
    ev_free (loop->vec_ri);
    ev_free (loop->vec_ro);
    ev_free (loop->vec_wi);
    ev_free (loop->vec_wo);
}


