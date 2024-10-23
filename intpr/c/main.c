
#include <stdio.h>

#include "./include/intpr.h"
#include "./include/parse.h"

#define UNIMPL(msg)                                                            \
  do {                                                                         \
    printf("[UNIMPL] %s", msg);                                                \
  } while (0)

int main(int argc, char **argv) {
  char *fname = argv[1];
  FILE *f = fopen(fname, "r");

  sexp_t fexp;
  if (parse_from_stream(f, &fexp) != 0) {
    perror("parse input file failed.");
  }

  if (eval(&fexp) != 0) {
    perror("evaluate input file failed.");
  }

  char input[1024];
  do {
    sexp_t iexp;
    if (fgets(input, sizeof(input), stdin) == NULL) {
      UNIMPL("some err occured.");
    }

    if (parse_from_buffer(input, &iexp) != 0) {
      perror("parse input file failed.");
    }

    if (eval(&iexp) != 0) {
      perror("evaluate input file failed.");
    }
  } while (1);

  return 0;
}
