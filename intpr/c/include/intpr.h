#ifndef INTPR_H
#define INTPR_H

#include "./parse.h"

typedef char *arg_t;
typedef arg_t *args_t;

typedef struct proc_t {
  args_t *vars;
  sexp_t *exp;
} proc_t;

typedef struct env_t {
  args_t *vars;
  args_t *vals;
  struct env_t *prev;
} env_t;

int eval(sexp_t *sexp);
int apply(proc_t *proc, args_t *vals, env_t env);

#endif
