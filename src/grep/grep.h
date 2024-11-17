#ifndef S21_GREP
#define S21_GREP

#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int e, i, v, c, l, n;
  int h, s, f, o;

  char *pattern;
  int len_pattern, mem_pattern;
} opt;

int parserflags(int argc, char **argv, opt *options);
int add_reg_from_file(opt *options, char *path);
int add_pattern(opt *options, char *pattern);
void print_match(regex_t *reg, char *line, int h, char *path);
void processFile(opt *options, char *path, regex_t *regex);
void output(opt options, int argc, char **argv);
void output_line(char *line, int n);

#endif