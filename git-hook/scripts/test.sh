#!/bin/sh

result_dir=".result"
if [ ! -d "$result_dir" ]; then
  mkdir -p "$result_dir"
fi

branch_name=$(git symbolic-ref --short HEAD)
result_dir="$result_dir/$branch_name"
if [ ! -d "$result_dir" ]; then
  mkdir -p "$result_dir"
fi

#result_lock="$result_dir/lock"
result_success="$result_dir/success"
result_fail="$result_dir/fail"

commit_id=$(git log -1 HEAD --format=%H)

out_file="$result_dir/$commit_id"

if [ ! -f "$out_file" ]
then
  #touch "$result_lock"
  rm $result_dir/* 2>/dev/null
  npm test > $out_file 2>&1
  test_result=`cat $out_file | grep "npm ERR! Test failed."`

  # this execution should be later than last one
  rm "$result_fail" 2>/dev/null
  rm "$result_success" 2>/dev/null

  if [ -n "$test_result" ]
  then
    touch "$result_fail"
  else 
    touch "$result_success"
  fi
fi

#rm "$result_lock" 2>/dev/null
