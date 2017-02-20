#!/bin/sh

test_description='git -c var=val'

. ./test-lib.sh

test_expect_success 'last one wins: two level vars' '
	echo VAL >expect &&

	# sec.var and sec.VAR are the same variable, as the first
	# and the last level of a configuration variable name is
	# case insensitive.  Test both setting and querying.

	git -c sec.var=val -c sec.VAR=VAL config --get sec.var >actual &&
	test_cmp expect actual &&
	git -c SEC.var=val -c sec.var=VAL config --get sec.var >actual &&
	test_cmp expect actual &&

	git -c sec.var=val -c sec.VAR=VAL config --get SEC.var >actual &&
	test_cmp expect actual &&
	git -c SEC.var=val -c sec.var=VAL config --get sec.VAR >actual &&
	test_cmp expect actual
'

test_expect_success 'last one wins: three level vars' '
	echo val >expect &&

	# v.a.r and v.A.r are not the same variable, as the middle
	# level of a three-level configuration variable name is
	# case sensitive.  Test both setting and querying.

	git -c v.a.r=val -c v.A.r=VAL config --get v.a.r >actual &&
	test_cmp expect actual &&
	git -c v.a.r=val -c v.A.r=VAL config --get V.a.R >actual &&
	test_cmp expect actual &&

	echo VAL >expect &&
	git -c v.a.r=val -c v.a.R=VAL config --get v.a.r >actual &&
	test_cmp expect actual &&
	git -c v.a.r=val -c V.a.r=VAL config --get v.a.r >actual &&
	test_cmp expect actual &&
	git -c v.a.r=val -c v.a.R=VAL config --get V.a.R >actual &&
	test_cmp expect actual &&
	git -c v.a.r=val -c V.a.r=VAL config --get V.a.R >actual &&
	test_cmp expect actual
'

test_done
