#ifndef __MY_DEBUG_H__
#define __MY_DEBUG_H__

#include <stdio.h>
#include <errno.h>
#include <string.h>

// taken directly from c.learncodethehardway.org/book/ex20.html
#ifdef NDEBUG
#define debug(M, ...)
#else
#define debug(M, ...) fprintf(stderr, "DEBUG %s:%d: " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#endif

#define clean_errno() (errno == 0 ? "None" : strerror(errno))

#define log_err(M, ...) fprintf(stderr, "[ERROR] (%s:%d: errno: %s) " M "\n", __FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

#define log_warn(M, ...) fprintf(stderr, "[WARN] (%s:%d: errno: %s) " M "\n", __FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

#define log_info(M, ...) fprintf(stderr, "[INFO] (%s:%d) " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)

#define check(A, M, ...) if(!(A)) { log_err(M, ##__VA_ARGS__); errno=0; goto error; }

#define sentinel(M, ...)  { log_err(M, ##__VA_ARGS__); errno=0; goto error; }

#define check_mem(A) check((A), "Out of memory.")

#define check_debug(A, M, ...) if(!(A)) { debug(M, ##__VA_ARGS__); errno=0; goto error; }

#ifdef _LINUX_HPROFILE

  #define PROFILE(description, block) \
    do  \
    {   \
      struct timeval start, end; \
      \
      gettimeofday(&start, NULL); \
      \
      do block while (0); \
      \
      gettimeofday(&end, NULL); \
      \
      fputs(description, stdout); \
      printf("%.2lf microseconds\n", time_diff(&start, &end)); \
    } while (0);

  double time_diff(struct timeval* x, struct timeval* y)
  {
      double x_ms , y_ms , diff;
       
      x_ms = (double)x->tv_sec*1000000 + (double)x->tv_usec;
      y_ms = (double)y->tv_sec*1000000 + (double)y->tv_usec;
       
      diff = (double)y_ms - (double)x_ms;
       
      return diff;
  }

#endif

#endif