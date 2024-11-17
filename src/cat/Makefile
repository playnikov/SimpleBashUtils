FILE_CAT=file_cat.txt
CFLAGS=-Wall -Wextra -Werror

all: s21_cat clean_cat

s21_cat: 
	gcc $(CFLAGS) -c cat.c main.c
	gcc $(CFLAGS) cat.o main.o -o s21_cat

clear: 
	rm -rf s21_cat

tests:
	./tests_cat/tests_cat.sh

clean_cat:
	rm -rf cat.o main.o 

rebuild: clear all