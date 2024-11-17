#!/bin/bash

SUCCESS='\033[0;32m'
FAILURE='\033[0;31m'
TESTS='\033[1;33m'
RUN_TEST='\033[0;35m'
NT='\e[0m'
TESTFILE='tests_grep/files'
REGFILE='tests_grep/regfiles'
RESULT='tests_grep/results'
FLAGS=("" "-e" "-i" "-v" "-c" "-l" "-n" "-h" "-o" "-in" "-iv")
FLAGS1=("" "-e" "-i" "-v" "-c" "-l" "-n") #-e, -i, -v, -c, -l, -n 
FLAGS2=("-h" "-o") # -h, -s, -f, -o
FLAGSF=("-f" "-if" "-vf" "-cf" "-lf" "-nf" "-hf" "-of" "-inf" "-ivf")
REGEX="a"

rm -f $RESULT/s21_result $RESULT/grep_result 
clear

make rebuild

if [ ! -d "$RESULT" ]; then
    mkdir "$RESULT"
fi

tests=0
tests_func=0
ok_tests=0

valgrind_test=0
ok_valgrind_test=0



printf "${TESTS}----------------------------------------TESTS #1----------------------------------------${NT}\n"

for file in $TESTFILE/*
do
	printf "${RUN_TEST}Running test: $file\n"
	for flag in "${FLAGS1[@]}"
	do
		((tests++))
		((tests_func++))
		printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$flag $REGEX $file':${NT}\n"
		grep $flag $REGEX $file > $RESULT/grep_result
		./s21_grep $flag $REGEX $file > $RESULT/s21_result
		error=$(diff $RESULT/grep_result $RESULT/s21_result)
		if [ ! "$error"  ]; then
			printf "   ${SUCCESS}[SUCCESS] ${NT}Test '$flag' ${NC}${SUCCESS}PASSED${NT}\n"
			((ok_tests++))
		else
			printf "   ${FAILURE}[FAIL] ${NT}Test '$flag' ${NT}${FAILURE}FAILED${NT}\n"
			printf "$error\n"
			exit 1;
		fi
		
		((tests++))
		((valgrind_test++))
		printf "${RUN_TEST}$tests:[START_TEST_V] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file':${NT}\n"
		valgrind_output=$(valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file 2>&1)
		errors_valngrind=$(echo "$valgrind_output" | grep "ERROR SUMMARY:" | awk '{print $4}')

		if [ "$errors_valngrind" -ne "0" ]; then 
			printf "   ${FAILURE}[FAIL] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file' ${NT}${FAILURE}FAILED${NT}\n"
			valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file
			printf "Количество ошибок: ${FAILURE}$errors_valngrind${NT}\n"
			exit 1
		else
			printf "   ${SUCCESS}[SUCCESS] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file' ${NC}${SUCCESS}PASSED${NT}\n"
			((ok_valgrind_test++))
		fi
	done
done


printf "${TESTS}----------------------------------------TESTS #2----------------------------------------${NT}\n"
for file in $TESTFILE/*
do
	printf "${RUN_TEST}Running test: $file\n"
	for flag in "${FLAGS2[@]}"
	do
		((tests++))
		((tests_func++))
		printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$flag $REGEX $file':${NT}\n"
		grep $flag $REGEX $file > $RESULT/grep_result
		./s21_grep $flag $REGEX $file > $RESULT/s21_result
		error=$(diff $RESULT/grep_result $RESULT/s21_result)
		if [ ! "$error"  ]; then
			printf "   ${SUCCESS}[SUCCESS] ${NT}Test '$flag' ${NC}${SUCCESS}PASSED${NT}\n"
			((ok_tests++))
		else
			printf "   ${FAILURE}[FAIL] ${NT}Test '$flag' ${NT}${FAILURE}FAILED${NT}\n"
			printf "$error\n"
			exit 1;
		fi

		((tests++))
		((valgrind_test++))
		printf "${RUN_TEST}$tests:[START_TEST_V] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file':${NT}\n"
		valgrind_output=$(valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file 2>&1)
		errors_valngrind=$(echo "$valgrind_output" | grep "ERROR SUMMARY:" | awk '{print $4}')

		if [ "$errors_valngrind" -ne "0" ]; then 
			printf "   ${FAILURE}[FAIL] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file' ${NT}${FAILURE}FAILED${NT}\n"
			echo $valgrind_output
			printf "Количество ошибок: ${FAILURE}$errors_valngrind${NT}\n"
			exit 1
		else
			printf "   ${SUCCESS}[SUCCESS] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep $flag $REGEX $file' ${NC}${SUCCESS}PASSED${NT}\n"
			((ok_valgrind_test++))
		fi
	done
done


printf "${TESTS}----------------------------------------TESTS #3----------------------------------------${NT}\n"
for file in $TESTFILE/*
do
	printf "${RUN_TEST}Running test: $file\n"
	for regfile in $REGFILE/*
	do
		((tests++))
		((tests_func++))
		printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '-f $regfile $file':${NT}\n"
		grep -f $regfile $file > $RESULT/grep_result
		./s21_grep -f $regfile $file > $RESULT/s21_result
		error=$(diff $RESULT/grep_result $RESULT/s21_result)
		if [ ! "$error"  ]; then
			printf "   ${SUCCESS}[SUCCESS] ${NT}Test '-f $regfile' ${NC}${SUCCESS}PASSED${NT}\n"
			((ok_tests++))
		else
			printf "   ${FAILURE}[FAIL] ${NT}Test '-f $regfile' ${NT}${FAILURE}FAILED${NT}\n"
			printf "$error\n"
			exit 1;
		fi
		((tests++))
		((valgrind_test++))
		printf "${RUN_TEST}$tests:[START_TEST_V] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep -f $regfile $file':${NT}\n"
		valgrind_output=$(valgrind --tool=memcheck --leak-check=yes ./s21_grep -f $regfile $file 2>&1)
		errors_valngrind=$(echo "$valgrind_output" | grep "ERROR SUMMARY:" | awk '{print $4}')

		if [ "$errors_valngrind" -ne "0" ]; then 
			printf "   ${FAILURE}[FAIL] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep -f $regfile $file' ${NT}${FAILURE}FAILED${NT}\n"
			echo $valgrind_output
			printf "Количество ошибок: ${FAILURE}$errors_valngrind${NT}\n"
			exit 1
		else
			printf "   ${SUCCESS}[SUCCESS] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_grep -f $regfile $file' ${NC}${SUCCESS}PASSED${NT}\n"
			((ok_valgrind_test++))
		fi
	done
done
	

# 	# for file in $TESTFILE/*
# 	# do
# 	# 	printf "${RUN_TEST}Running test: $file\n"
# 	# 	for regfile in $REGFILE/*
# 	# 	do
# 	# 		for flag in "${FLAGS2[@]}"
# 	# 		do
# 	# 			((tests++))
# 	# 			printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$flag $regfile $file':${NT}\n"
# 	# 			grep $flag $regfile $file > $RESULT/grep_result
# 	# 	  		../s21_grep $flag $regfile $file > $RESULT/s21_result
# 	# 	  		error=$(diff $RESULT/grep_result $RESULT/s21_result)
# 	# 	  		if [ ! "$error"  ]; then
# 	# 	      			printf "   ${SUCCESS}[SUCCESS] ${NT}Test '$flag $regfile' ${NC}${SUCCESS}PASSED${NT}\n"
# 	# 	      			((ok_tests++))
# 	# 	    		else
# 	# 	      			printf "   ${FAILURE}[FAIL] ${NT}Test '$flag $regfile' ${NT}${FAILURE}FAILED${NT}\n"
# 	# 	      			printf "$error\n"
# 	# 	      		fi
# 	# 		done
# 	# 	done
# 	# done

# 	# printf "${RUN_TEST}Running test: $TESTFILE/sadasdasdasd.txt\n"
# 	# ((tests++))
# 	# printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '-s $REGEX $TESTFILE':${NT}\n"
# 	# grep -s $REGEX $TESTFILE/sadasdasdasd.txt > $RESULT/grep_result
# 	# ../s21_grep -s $REGEX $TESTFILE/sadasdasdasd.txt > $RESULT/s21_result
# 	# error=$(diff $RESULT/grep_result $RESULT/s21_result)
# 	# if [ ! "$error"  ]; then
# 	# 	printf "   ${SUCCESS}[SUCCESS] ${NT}Test '-s' ${NC}${SUCCESS}PASSED${NT}\n"
# 	# 	((ok_tests++))
# 	# else
# 	# 	printf "   ${FAILURE}[FAIL] ${NT}Test '-s' ${NT}${FAILURE}FAILED${NT}\n"
# 	# 	printf "$error\n"
# 	# 	exit 1;
# 	# fi
# fi

# printf "${TESTS}------------------------------------PROCESS------------------------------------------${NT}\n"

# for file in $TESTFILE/*
# do
# 	printf "${RUN_TEST}Running test: $file\n"
# 	for regfile in $REGFILE/*
# 	do
#       		for flag in "${FLAGSF[@]}"
# 		do
# 			((tests++))
# 			printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$flag $regfile $file':${NT}\n"
# 			grep $flag $regfile $file > $RESULT/grep_result
# 	  		../s21_grep $flag $regfile $file > $RESULT/s21_result
# 	  		error=$(diff $RESULT/grep_result $RESULT/s21_result)
# 	  		if [ ! "$error"  ]; then
# 	      			printf "   ${SUCCESS}[SUCCESS] ${NT}Test '$flag $regfile' ${NC}${SUCCESS}PASSED${NT}\n"
# 	      			((ok_tests++))
# 	    		else
# 	      			printf "   ${FAILURE}[FAIL] ${NT}Test '$flag $regfile' ${NT}${FAILURE}FAILED${NT}\n"
# 	      			printf "$error\n"
# 	      		fi
# 		done
# 	done
	
# done

# printf "${TESTS}------------------------------------PROCESS------------------------------------------${NT}\n"

# printf "${RUN_TEST}Running test: $TESTFILE/*\n"
# for flag in "${FLAGS[@]}"
# do
# 	((tests++))
# 	printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$flag $REGEX $TESTFILE/*':${NT}\n"
# 	grep $flag $REGEX $TESTFILE/* > $RESULT/grep_result
# 	../s21_grep $flag $REGEX $TESTFILE/* > $RESULT/s21_result
# 	error=$(diff $RESULT/grep_result $RESULT/s21_result)
# 	if [ ! "$error"  ]; then
# 		printf "   ${SUCCESS}[SUCCESS] ${NT}Test '$flag' ${NC}${SUCCESS}PASSED${NT}\n"
# 		((ok_tests++))
# 	else
# 		printf "   ${FAILURE}[FAIL] ${NT}Test '$flag' ${NT}${FAILURE}FAILED${NT}\n"
# 		printf "$error\n"
# 	fi
# done

# printf "${TESTS}------------------------------------PROCESS------------------------------------------${NT}\n"

# printf "${RUN_TEST}Running test: $TESTFILE/sadasdasdasd.txt\n"
# ((tests++))
# printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '-s $REGEX $TESTFILE':${NT}\n"
# grep -s $REGEX $TESTFILE/sadasdasdasd.txt > $RESULT/grep_result
# ../s21_grep -s $REGEX $TESTFILE/sadasdasdasd.txt > $RESULT/s21_result
# error=$(diff $RESULT/grep_result $RESULT/s21_result)
# if [ ! "$error"  ]; then
# 	printf "   ${SUCCESS}[SUCCESS] ${NT}Test '-s' ${NC}${SUCCESS}PASSED${NT}\n"
# 	((ok_tests++))
# else
# 	printf "   ${FAILURE}[FAIL] ${NT}Test '-s' ${NT}${FAILURE}FAILED${NT}\n"
# 	printf "$error\n"
# fi

printf "${TESTS}-----------------------------------------FINISH-----------------------------------------${NT}\n"


if ((ok_tests * 100 / tests_func > 75)); then
	printf "${TESTS}Test functions:${SUCCESS} $ok_tests / ${NT}$tests_func\n"
else 
	printf "${TESTS}Test functions:${FAILURE} $ok_tests / ${NT}$tests_func\n"
fi

if ((ok_valgrind_test * 100 / valgrind_test > 75)); then
	printf "${TESTS}Test valgrind:${SUCCESS} $ok_valgrind_test / ${NT}$valgrind_test\n"
else 
	printf "${TESTS}Test valgrind:${FAILURE} $ok_valgrind_test / ${NT}$valgrind_test\n"
fi
all_test_ok=$((ok_valgrind_test+ok_tests))
if ((all_test_ok * 100 / tests > 90)); then
	printf "${TESTS}Test valgrind:${SUCCESS} $all_test_ok / ${NT}$tests\n"
else 
	printf "${TESTS}Test all:${FAILURE} $all_test_ok / ${NT}$tests\n"
fi

rm -f $RESULT/s21_result $RESULT/grep_result 
