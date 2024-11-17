FILE_GREP=file_grep.txt
CFLAGS=-Wall -Wextra -Werror


all: s21_grep clean_grep

s21_grep: 
	gcc $(CFLAGS) -c grep_parser.c grep_print.c main.c
	gcc $(CFLAGS) grep_parser.o grep_print.o main.o -o s21_grep

tests:
	./tests_grep/tests_grep.sh 2 3

clear: 
	rm -rf s21_grep

clean_grep:
	rm -rf grep_parser.o grep_print.o main.o

rebuild: clear all