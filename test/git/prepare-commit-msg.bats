#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"
  git init
}

@test "prepare-commit-msg: master/develop should not be changed locally." {
  git config user.email wangzengdi@meituan.com
  bash $HOOK_TEST_INSTALL_PATH/git-client-hook.sh
  git add .
  run git commit -m "commit message"
  assert_output_contains  "warning: Branch master should not be changed locally! ⛔️ "

  git checkout -b develop
  echo 'new file' > new_file.js
  git add .
  run git commit -m "commit message"
  assert_output_contains  "warning: Branch develop should not be changed locally! ⛔️ "
}

@test "prepare-commit-msg: branch name should contains jira task." {
  git config user.email wangzengdi@meituan.com
  bash $HOOK_TEST_INSTALL_PATH/git-client-hook.sh
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m "commit message"
  assert_success

  git checkout -b release
  echo 'new file' > new_file.js
  git add .
  run git commit -m "commit message"
  assert_output_contains "Branch name: \"release\" does not match JIRA format. Please change it !!! ✏️ "
}

@test "prepare-commit-msg: commit message should not be empty." {
  git config user.email wangzengdi@meituan.com
  bash $HOOK_TEST_INSTALL_PATH/git-client-hook.sh
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m ""
  assert_failure "Commit message should not be Empty! Write Sth about the commit. ✏️ "

  run git commit -m "commit message"
  assert_success
}

@test "prepare-commit-msg: branch name will not add again if commit message contains it already." {
  git config user.email wangzengdi@meituan.com
  bash $HOOK_TEST_INSTALL_PATH/git-client-hook.sh
  git checkout -b feature/TASK-9527
  git add .
  run git commit -m "feature/TASK-9527 branch name alread in commit message"
  assert_success
}
