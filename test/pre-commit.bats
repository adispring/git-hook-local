#!/usr/bin/env bats
load test_helper

@test "is_valid_email should exit 1 if email format is invalid." {
  cd "$HOOK_TEST_PATH"
  git init
  git config user.email sunnyadi@163.com
  run pre-commit
  assert_line 0 "Git commit FAILED! ❌ "
  assert_line 1 "Git user.email: sunnyadi@163.com is invalid, please use company's email! ✏️ "
}

@test "is_valid_email should exit 0 if email format is valid." {
  cd "$HOOK_TEST_PATH"
  git init
  git config user.email wangzengdi@meituan.com
  run pre-commit
  assert_success
}

