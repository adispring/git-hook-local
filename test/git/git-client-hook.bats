#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"
  chmod a+x "${HOOK_TEST_INSTALL_PATH}/git-client-hook.sh"
}

@test "If no .git/ dir exist, hook will not install." {
  run git-client-hook.sh
  assert_success "No ${HOOK_TEST_PATH}/.git/hooks exist!"

  git init
  run git-client-hook.sh
  refute_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"
}

@test "Hook will install only when NODE_ENV equals undefined or development" {
  git init

  unset NODE_ENV
  export NODE_ENV
  run git-client-hook.sh
  refute_output_contains "No need to install git-hook in NODE_ENV: "

  export NODE_ENV="development"
  run git-client-hook.sh
  refute_output_contains "No need to install git-hook in NODE_ENV: "

  export NODE_ENV="production"
  run git-client-hook.sh
  assert_output "No need to install git-hook in NODE_ENV: production."

  export NODE_ENV="release"
  run git-client-hook.sh
  assert_output "No need to install git-hook in NODE_ENV: release."
}

