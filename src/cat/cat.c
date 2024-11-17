#include "cat.h"

int checkflags(int argc, char **argv, opt *options) {
  int error = 0;
  static struct option long_option[] = {{"number-nonblank", 0, 0, 'b'},
                                        {"number", 0, 0, 'n'},
                                        {"squeeze-blank", 0, 0, 's'},
                                        {0, 0, 0, 0}};
  int opt;
  while ((opt = getopt_long(argc, argv, "benvstvTE", long_option, NULL)) !=
         -1) {
    switch (opt) {
      case 'b':
        options->b = 1;
        break;
      case 'e':
        options->e = 1;
        options->v = 1;
        break;
      case 'E':
        options->e = 1;
        break;
      case 't':
        options->t = 1;
        options->v = 1;
        break;
      case 'T':
        options->t = 1;
        break;
      case 'n':
        options->n = 1;
        break;
      case 's':
        options->s = 1;
        break;
      case 'v':
        options->v = 1;
        break;
      default:
        fprintf(stderr, "Try 'cat --help' for more information.\n");
        error = 1;
    }
  };
  if (options->b) options->n = 0;
  return error;
}

void print_file(char **argv, int argc, opt *options) {
  int str_counter = 0, counter = 0, empty_count = 1, current;
  for (int i = optind; i < argc; i++) {
    FILE *fp = fopen(argv[i], "r");
    if (fp) {
      while ((current = fgetc(fp)) != EOF) {
        if ((options->b && current != '\n') || options->n) {
          if (counter == 0) {
            printf("%6d\t", ++(str_counter));
            counter = 1;
          }
        }
        if (options->e && (current == '\n')) {
          printf("$");
        }

        if (current == '\n') {
          counter = 0;
          if (options->s) {
            empty_count++;
          }
        } else {
          empty_count = 0;
        }
        if (options->v) {
          if (options->t && current == '\t') {
            printf("^I");
          } else {
            flag_v(current);
          }
        } else if (options->t && current == '\t') {
          printf("^I");
        } else if (!options->s || empty_count <= 2) {
          printf("%c", current);
        }
      }
      fclose(fp);
    } else {
      fprintf(stderr, "cat: %s: No such file or directory\n", argv[i]);
    }
  }
}

void flag_v(int current) {
  if ((current < 32 && current != '\t' && current != '\n')) {
    printf("^%c", current + 64);
  } else if (current == 127) {
    printf("^?");
  } else if (current > 127 && current <= 159) {
    printf("M-^%c", current - 64);
  } else if (current >= 160 && current <= 254) {
    printf("M-%c", current - 128);
  } else if (current == 255) {
    printf("M-^?");
  } else {
    printf("%c", current);
  }
}