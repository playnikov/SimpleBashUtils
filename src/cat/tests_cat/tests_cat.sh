#!/bin/bash

SUCCESS='\033[0;32m'
FAILURE='\033[0;31m'
TESTS='\033[1;33m'
RUN_TEST='\033[0;35m'
NT='\e[0m'
TESTFILE='tests_cat/files'
RESULT='tests_cat/results'
FLAGS=("-b" "-e" "-n" "-s" "-t" "-v" "-E" "-T" "--number-nonblank" "--number" "--squeeze-blank")

rm -f $RESULT/s21_result $RESULT/cat_result

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


start_time=$(date +%s.%N)

printf "${TESTS}----------------------------------------TESTS #1----------------------------------------${NT}\n"

for file in $TESTFILE/*
do
	printf "${RUN_TEST}Running test: $file\n"
	for flag in "${FLAGS[@]}"
	do
		((tests++))
		((tests_func++))
		printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$flag $file':${NT}\n"
		cat $flag $file > $RESULT/cat_result
  		./s21_cat $flag $file > $RESULT/s21_result
  		error=$(diff $RESULT/cat_result $RESULT/s21_result)
  		if [ ! "$error"  ]; then
			printf "   ${SUCCESS}[SUCCESS] ${NT}Test '$flag' ${NC}${SUCCESS}PASSED${NT}\n"
			((ok_tests++))
		else
			printf "   ${FAILURE}[FAIL] ${NT}Test '$flag' ${NT}${FAILURE}FAILED${NT}\n"
			printf "$error\n"
			end_time=$(date +%s.%N)
			execution_time=$(echo "$end_time - $start_time" | bc)
			echo "Время выполнения: $execution_time секунд"
			exit 1;
		fi
	done
done

printf "${RUN_TEST}Running test: $TESTFILE/*\n"
((tests++))
((tests_func++))
printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$TESTFILE/*':${NT}\n"
cat $TESTFILE/* > $RESULT/cat_result
./s21_cat $TESTFILE/* > $RESULT/s21_result
error=$(diff $RESULT/cat_result $RESULT/s21_result)
if [ ! "$error"  ]; then
	printf "   ${SUCCESS}[SUCCESS] ${NT}Test '$TESTFILE/*' ${NC}${SUCCESS}PASSED${NT}\n"
	((ok_tests++))
else
	printf "   ${FAILURE}[FAIL] ${NT}Test '$TESTFILE/*' ${NT}${FAILURE}FAILED${NT}\n"
	printf "$error\n"
	end_time=$(date +%s.%N)
	execution_time=$(echo "$end_time - $start_time" | bc)
	echo "Время выполнения: $execution_time секунд"
	exit 1;
fi
# ((tests++))
# ((valgrind_test++))
# printf "${RUN_TEST}$tests:[START_TEST_V] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_cat $TESTFILE/*':${NT}\n"
# valgrind_output=$(valgrind --tool=memcheck --leak-check=yes ./s21_cat $TESTFILE/* 2>&1)
# errors_valngrind=$(echo "$valgrind_output" | grep "ERROR SUMMARY:" | awk '{print $4}')

# if [ "$errors_valngrind" -ne "0" ]; then 
# 	printf "   ${FAILURE}[FAIL] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_cat $TESTFILE/*' ${NT}${FAILURE}FAILED${NT}\n"
# 	printf "Количество ошибок: ${FAILURE}$errors_valngrind${NT}\n"
# 	exit 1
# else
# 	printf "   ${SUCCESS}[SUCCESS] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes ./s21_cat $TESTFILE/*' ${NC}${SUCCESS}PASSED${NT}\n"
# 	((ok_valgrind_test++))
# fi
# printf "${TESTS}----------------------------------------TESTS #2----------------------------------------${NT}\n"

# for file in $TESTFILE/*
# do
# 	printf "${RUN_TEST}Running test: $file\n"
# 	for flag in "${FLAGS[@]}"
# 	do
# 		((tests++))
# 		printf "${RUN_TEST}$tests:[START_TEST] ${NT}Test '$flag $file':${NT}\n"
# 		valgrind --tool=memcheck --leak-check=yes --error-exitcode=1 ./s21_cat $flag $file > $RESULT/valgrind_test 2>&1
#   		if [ $? -eq 0  ]; then
# 			printf "   ${SUCCESS}[SUCCESS] ${NT}Test valgrind --tool=memcheck --leak-check=yes --error-exitcode=1 ./s21_cat $flag $file ${NC}${SUCCESS}PASSED${NT}\n"
# 			((ok_tests++))
# 		else
# 			printf "   ${FAILURE}[FAIL] ${NT}Test 'valgrind --tool=memcheck --leak-check=yes --error-exitcode=1 ./s21_cat $flag $file' ${NT}${FAILURE}FAILED${NT}\n"
# 			cat $RESULT/valgrind_test
# 			exit 1;
# 		fi
# 	done
# done

printf "${TESTS}-----------------------------------------FINISH-----------------------------------------${NT}\n"

end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc)
echo "Время выполнения: $execution_time секунд"

if ((ok_tests * 100 / tests_func > 75)); then
	printf "${TESTS}Test functions:${SUCCESS} $ok_tests / ${NT}$tests_func\n"
else 
	printf "${TESTS}Test functions:${FAILURE} $ok_tests / ${NT}$tests_func\n"
fi

# if ((ok_valgrind_test * 100 / valgrind_test > 75)); then
# 	printf "${TESTS}Test valgrind:${SUCCESS} $ok_valgrind_test / ${NT}$valgrind_test\n"
# else 
# 	printf "${TESTS}Test valgrind:${FAILURE} $ok_valgrind_test / ${NT}$valgrind_test\n"
# fi
all_test_ok=$((ok_valgrind_test+ok_tests))
if ((all_test_ok * 100 / tests > 90)); then
	printf "${TESTS}Test valgrind:${SUCCESS} $all_test_ok / ${NT}$tests\n"
else 
	printf "${TESTS}Test valgrind:${FAILURE} $all_test_ok / ${NT}$tests\n"
fi

rm -f $RESULT/s21_result $RESULT/grep_result $RESULT/valgrind_result



rm -f $RESULT/s21_result $RESULT/cat_result $RESULT/valgrind_test

