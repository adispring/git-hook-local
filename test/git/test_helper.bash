#!/usr/bin/env bash

load ../../node_modules/bats-assert/all

# Set path vars
export TESTS_PATH="$BATS_TEST_DIRNAME"
export PROJECT_PATH="$(cd "$TESTS_PATH/../.." && pwd)"
export INSTALL_SCRIPT_PATH="$PROJECT_PATH/git-hook"

if [ -z "$HOOK_TEST_PATH" ]; then
  if [ -n "$TMPDIR" ]; then
   #HOOK_TEST_PATH="$TMPDIR/git-hook-local-temp"
    HOOK_TEST_PATH="$HOME/tmp/git-hook-local-temp"
  else
    HOOK_TEST_PATH="$HOME/tmp/git-hook-local-temp"
  fi
  #export HOOK_TEST_PATH="$(mktemp -d "${HOOK_TEST_PATH}.XXX" 2>/dev/null || echo "$HOOK_TEST_PATH")"
  export HOOK_TEST_PATH
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"

  export HOOK_TEST_INSTALL_PATH="$HOOK_TEST_PATH/git-hook"
  export HOOK_TEST_REPO_PATH="$HOOK_TEST_PATH/git-hook/hooks"

  PATH="$HOOK_TEST_INSTALL_PATH:$PATH"
  PATH="$HOOK_TEST_REPO_PATH:$PATH"
  export PATH
fi

teardown() {
  rm -rf "$HOOK_TEST_PATH"
}

