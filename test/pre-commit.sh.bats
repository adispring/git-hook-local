#!/usr/bin/env bats
load ../node_modules/bats-assert/all

setup() {
  source "${BATS_TEST_DIRNAME}/../git-hook/hooks/pre-commit.hook"
}

@test "is_valid_email should exit 1 if email format is invalid." {
  run is_valid_email sunnyadi@163.com
  assert_line 0 "Git commit FAILED! ❌ "
  assert_line 1 "Git user.email: sunnyadi@163.com is invalid, please use company's email! ✏️ "

  run is_valid_email wangzengdi@meituan.com
  [[ $status == 0 ]]
  [[ -z "$output" ]]
}

