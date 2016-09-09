#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"
}

@test "Hook will install only when NODE_ENV equals undefined or development" {
  chmod a+x "${HOOK_TEST_INSTALL_PATH}/git-client-hook.sh"
  run git-client-hook.sh
  assert_success "No ${HOOK_TEST_PATH}/.git/hooks exist!"
}

