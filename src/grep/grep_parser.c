#include "grep.h"

// int e, i, v, c, l, n;
// int h, s, f, o;
int parserflags(int argc, char** argv, opt* options) {
  int error = 0, opt;
  while ((opt = getopt(argc, argv, "e:ivclnhsf:o")) != -1) {
    switch (opt) {
      case 'e':
        options->e = 1;
        add_pattern(options, optarg);
        break;
      case 'i':
        options->i = REG_ICASE;
        break;
      case 'v':
        options->v = 1;
        break;
      case 'c':
        options->c = 1;
        break;
      case 'l':
        options->l = 1;
        break;
      case 'n':
        options->n = 1;
        break;
      case 'h':
        options->h = 1;
        break;
      case 's':
        options->s = 1;
        break;
      case 'f':
        options->f = 1;
        error = add_reg_from_file(options, optarg);
        break;
      case 'o':
        options->o = 1;
        break;
      default:
        fprintf(stderr, "Try 'grep --help' for more information.\n");
        error = 1;
    }
  }
  if (!error) {
    if (options->pattern == NULL) {
      add_pattern(options, argv[optind]);
      optind++;
    }
    if (argc - optind == 1) {
      options->h = 1;
    }
  }
  return error;
}

int add_reg_from_file(opt* options, char* path) {
  int error = 0;
  FILE* fp = fopen(path, "r");
  if (fp == NULL) {
    if (!options->s) fprintf(stderr, "Can't open file %s\n", path);
    error = 1;
  } else {
    char* line = NULL;
    size_t len = 0;
    int read;
    while ((read = getline(&line, &len, fp)) != -1) {
      if (line[read - 1] == '\n') {
        line[read - 1] = '\0';
      }
      add_pattern(options, line);
    }
    free(line);
    fclose(fp);
  }
  return error;
}

int add_pattern(opt* options, char* pattern) {
  int error = 0;
  int n = strlen(pattern);
  if (options->len_pattern == 0) {
    if ((options->pattern = malloc((n + 1) * sizeof(char))) != NULL) {
      options->mem_pattern += 1;
    } else {
      error = 1;
    }
  }
  if (options->len_pattern + n + 2 > options->mem_pattern && !error) {
    if ((options->pattern = realloc(
             options->pattern,
             ((options->mem_pattern * 2 + n + 2) * sizeof(char)))) != NULL) {
      options->mem_pattern = options->mem_pattern * 2 + n + 2;
    } else {
      error = 1;
    }
  }
  if (options->len_pattern != 0 && !error) {
    strcat(options->pattern + options->len_pattern, "\\|");
    options->len_pattern += 2;
  }
  if (!error) {
    options->len_pattern +=
        sprintf(options->pattern + options->len_pattern, "%s", pattern);
  }
  return error;
}