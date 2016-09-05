#!/usr/bin/env bats
load ../node_modules/bats-assert/all

setup() {
  source "${BATS_TEST_DIRNAME}/../git-hook/git-client-hook.sh"
}

@test "is_node_env_dev should return 0 and no output if NODE_ENV is null/development" {
  run is_node_env_dev
  [[ $status == 0 ]]
  [[ -z "$output" ]]

  run is_node_env_dev development
  [[ $status == 0 ]]
  [[ -z "$output" ]]
}

@test "is_node_env_dev should exit 0 and output some tips if NODE_ENV != null&development" {
  run is_node_env_dev production
  assert_success  "No need to install git-hook in NODE_ENV: production."

  run is_node_env_dev release
  assert_success  "No need to install git-hook in NODE_ENV: release."
}

@test "has_git_hooks_path should exit 0 and some tips if .git/hooks not exit." {
  run has_git_hooks_path $GIT_HOOK_PATH
  [[ $status == 0 ]]
  [[ -z "$output" ]]

  run has_git_hooks_path ${GIT_HOOK_PATH}_NO_EXIST
  assert_success  "No ${GIT_HOOK_PATH}_NO_EXIST exist!"
}

@test "addition using bc" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}
