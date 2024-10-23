#ifndef PARSE_H
#define PARSE_H

#include <stdio.h>

struct sexp_t {
  struct sexp_t *children;
};
typedef struct sexp_t sexp_t;

int parse_from_buffer(char *buf, sexp_t *sexp);
int parse_from_stream(FILE *file, sexp_t *sexp);

int lexer(char *buf, sexp_t *sexp); // TODO: how to make a clean lexer struct

#endif
