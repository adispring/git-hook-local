#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"
  cp "$HOOK_TEST_INSTALL_PATH/test/git/package.json" "$HOOK_TEST_PATH/package.json"
  git init
}

@test "pre-commit: should exit 1 if email format is invalid" {
  git config user.email sunnyadi@163.com
  run pre-commit
  assert_failure
  assert_line 0 "Git commit FAILED! ❌ "
  assert_line 1 "Git user.email: sunnyadi@163.com is invalid, please use company's email! ✏️ "
}

@test "pre-commit: should exit 0 if email format is valid." {
  git config user.email wangzengdi@meituan.com
  run pre-commit
  assert_success
}

