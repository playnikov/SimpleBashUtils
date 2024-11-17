#ifndef S21_CAT
#define S21_CAT

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int b, e, n, s, t, v;
} opt;

void print_file(char **argv, int argc, opt *options);
int checkflags(int argc, char **argv, opt *options);
void flag_v(int current);

#endif