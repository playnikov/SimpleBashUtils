#include "grep.h"

int main(int argc, char** argv) {
  int error = 0;
  if (argc < 3) {
    fprintf(stderr,
            "Usage: grep [OPTION]... PATTERNS [FILE]...\nTry 'grep --help' for "
            "more information.);\n");
  } else {
    opt options = {0};
    error = parserflags(argc, argv, &options);
    if (!error) {
      output(options, argc, argv);
    }
    if (options.pattern != NULL) {
      free(options.pattern);
    }
  }

  return error;
}