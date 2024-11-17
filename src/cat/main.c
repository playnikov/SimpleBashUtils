#include "cat.h"

int main(int argc, char **argv) {
  int error = 0;
  if (argc < 2) {
    fprintf(stderr, "usage: cat [OPTION] [FILENAME]\n");
  } else {
    opt options = {0};
    error = checkflags(argc, argv, &options);
    if (!error) {
      print_file(argv, argc, &options);
    }
  }

  return error;
}