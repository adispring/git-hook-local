#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"
}

@test "Hook will install only when NODE_ENV equals undefined or development" {
  git init
  
  unset NODE_ENV
  run git-client-hook.sh
  assert_success
}

