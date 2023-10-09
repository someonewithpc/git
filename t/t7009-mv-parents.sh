#!/bin/sh

test_description='git mv -p'
GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME=main
export GIT_TEST_DEFAULT_INITIAL_BRANCH_NAME

. ./test-lib.sh

test_expect_success 'mv fails to move a file if the target directory does not exist' '
	echo test >test1 &&
	git add test1 &&
	test_must_fail git mv test1 foo/
'

test_expect_success 'mv fails to move multiple files if the target directory does not exist' '
	echo test >test2-1 &&
	echo test >test2-2 &&
	git add test2-1 test2-2 &&
	test_must_fail git mv test2-1 test2-2 foo/
'

test_expect_success 'mv fails to move a file if the target refers to a file in a directory that does not exist' '
	echo test >test3 &&
	git add test3 &&
	test_must_fail git mv test3 foo/test3.txt
'

test_expect_success 'mv succeeds to move a file even if the target directory does not exist' '
	echo test >test4 &&
	git add test4 &&
	git commit -m test4-commit1 &&
	git mv -p test4 dir4/ &&
	git commit -m test4-commit2 &&
	git diff-tree -r -M --name-status HEAD^ HEAD >test4-actual &&
	grep "^R100..*test4..*dir4/test4" test4-actual
'

test_expect_success 'mv succeeds to move multiple files even if the target directory does not exist' '
	echo test >test5-1 &&
	echo test >test5-2 &&
	git add test5-1 test5-2 &&
	git commit -m test5-commit1 &&
	git mv -p test5-1 test5-2 dir5/ &&
	git commit -m test5-commit2 &&
	git diff-tree -r -M --name-status HEAD^ HEAD >test5-actual &&
	grep -e "^R100..*test5-1..*dir5/test5-1" -e "^R100..*test5-2..*dir5/test5-2" test5-actual
'

test_expect_success 'mv succeeds to move a file even if the target refers to a file in a directory that does not exist' '
	echo test >test6 &&
	git add test6 &&
	git commit -m test6-commmit-1 &&
	git mv -p test6 dir6/test6.txt &&
	git commit -m test6-commit2 &&
	git diff-tree -r -M --name-status HEAD^ HEAD >test6-actual &&
	grep "^R100..*test6..*dir6/test6.txt" test6-actual
'

test_expect_success 'mv succeeds to move a file even if the target refers to a file in a directory inside a directory that does not exist' '
	echo test >test7 &&
	git add test7 &&
	git commit -m test7-commit1 &&
	git mv -p test7 dir7/dir7/test7.txt &&
	git commit -m test7-commit2 &&
	git diff-tree -r -M --name-status HEAD^ HEAD >test7-actual &&
	grep "^R100..*test7..*dir7/dir7/test7.txt" test7-actual
'

test_expect_success 'mv succeeds to move a file even if the target refers to a file in a directory inside a directory inside a directory that does not exist' '
	echo test >test8 &&
	git add test8 &&
	git commit -m test8-commit1 &&
	git mv -p test8 dir8/dir8/dir8/test8.txt &&
	git commit -m test8-commit2 &&
	git diff-tree -r -M --name-status HEAD^ HEAD >test8-actual &&
	grep "^R100..*test8..*dir8/dir8/dir8/test8.txt" test8-actual
'

test_done
