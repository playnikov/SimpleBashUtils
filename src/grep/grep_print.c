#include "grep.h"

void processFile(opt* options, char* path, regex_t* regex) {
  FILE* fp = fopen(path, "r");
  if (fp == NULL) {
    if (!options->s) fprintf(stderr, "Can't open file %s\n", path);
  } else {
    char* line = NULL;
    size_t memlen = 0;
    int read, line_num = 1, c = 0;
    while ((read = getline(&line, &memlen, fp)) != -1) {
      int result = regexec(regex, line, 0, NULL, 0);

      if ((result == 0 && !options->v) || (result != 0 && options->v)) {
        if (!options->c && !options->l) {
          if (!options->h && !options->o) printf("%s:", path);
          if (options->n) printf("%d:", line_num);
          if (options->o) {
            print_match(regex, line, options->h, path);
          } else {
            output_line(line, read);
          }
        }
        c++;
      }
      line_num++;
    }
    free(line);
    if (options->c && !options->l) {
      if (!options->h) printf("%s:", path);
      printf("%d\n", c);
    }
    if (options->l && c > 0) printf("%s\n", path);
    fclose(fp);
  }
}

void output(opt options, int argc, char** argv) {
  regex_t re;
  int error = regcomp(&re, options.pattern, options.i);
  if (error) {
    if (!options.s) fprintf(stderr, "Invalid regular expression\n");
  }
  for (int i = optind; i < argc; i++) {
    processFile(&options, argv[i], &re);
  }
  if (!error) {
    regfree(&re);
  }
}

void output_line(char* line, int n) {
  for (int i = 0; i < n; i++) {
    putchar(line[i]);
  }
  if (line[n - 1] != '\n') putchar('\n');
}

void print_match(regex_t* reg, char* line, int h, char* path) {
  regmatch_t match;
  int result, offset = 0;
  while ((result = regexec(reg, line + offset, 1, &match, 0)) == 0) {
    if (h == 0) printf("%s:", path);
    for (int i = match.rm_so; i < match.rm_eo; i++) {
      putchar(line[offset + i]);
    }
    putchar('\n');
    offset += match.rm_eo;
  }
}