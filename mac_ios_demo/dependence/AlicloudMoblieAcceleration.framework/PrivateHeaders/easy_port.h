#ifndef EASY_PORT_H_
#define EASY_PORT_H_
#include <stdint.h>

/////// 自定义define区 ////////
//
//
//
/////// 自定义define区 ////////

#if OSX
# ifndef __UINT64_C
#  if __WORDSIZE == 64
#   define __INT64_C(c)  c ## L
#   define __UINT64_C(c) c ## UL
#  else
#   define __INT64_C(c)  c ## LL                                                                                                                                                               
#   define __UINT64_C(c) c ## ULL
#  endif
# endif
#endif

#if defined(HAVE_LIBSLIGHTSSL)
//目前bio只支持在slightsslv2中使用
# define EASY_USE_BIO
#endif

//size_t在printf里的placeholder
#if __WORDSIZE == 64
# define Psize_t "lu"
#else
# define Psize_t "u"
#endif

#endif
