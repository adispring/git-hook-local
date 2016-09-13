#!/usr/bin/env bats
load test_helper

setup() {
  mkdir -p "$HOOK_TEST_PATH"
  cd "$HOOK_TEST_PATH"
  cp -rf "$INSTALL_SCRIPT_PATH" "$HOOK_TEST_PATH"
  cp "$HOOK_TEST_INSTALL_PATH/test/package.json" "$HOOK_TEST_PATH/package.json"
  echo $(ls "$HOOK_TEST_INSTALL_PATH/test/package.json") >&2 
  chmod a+x "${HOOK_TEST_INSTALL_PATH}/git-client-hook.sh"
}

@test "git-client-hook: If no .git/ dir exist, hook will not install." {
  run git-client-hook.sh
  assert_success "No ${HOOK_TEST_PATH}/.git/hooks exist!"

  git init
  run git-client-hook.sh
  refute_output_contains "No ${HOOK_TEST_PATH}/.git/hooks exist!"
}

@test "git-client-hook: Hook will install only when NODE_ENV equals undefined or development" {
  git init
  (
    unset NODE_ENV
    export NODE_ENV
    run git-client-hook.sh
    refute_output_contains "No need to install git-hook in NODE_ENV: "
  )
  NODE_ENV="development" run git-client-hook.sh
  refute_output_contains "No need to install git-hook in NODE_ENV: "

  NODE_ENV="production" run git-client-hook.sh
  assert_output "No need to install git-hook in NODE_ENV: production."

  NODE_ENV="release" run git-client-hook.sh
  assert_output "No need to install git-hook in NODE_ENV: release."
}

@test "git-client-hook: Hook will install/update only if there are some new hook files/contents." {
  git init

  HOOK_TEST_FILE_NAMES=($(ls $HOOK_TEST_REPO_PATH))
  NODE_ENV="development" run git-client-hook.sh
  assert_output_contains "GIT LOCAL HOOK installing...! ⚙ "
  assert_output_contains "GIT LOCAL HOOK install done!  🍻"
  for hook_file in ${HOOK_TEST_FILE_NAMES[@]}
  do
    assert_output_contains "$hook_file installing..."
    assert_output_contains "$hook_file installed!"
  done

  echo "#add sth to git_hook" >> "$HOOK_TEST_REPO_PATH/${HOOK_TEST_FILE_NAMES[0]}"
  run git-client-hook.sh
  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} has changed: "
  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updating..."
  assert_output_contains "${HOOK_TEST_FILE_NAMES[0]} updated!"

  run git-client-hook.sh
  assert_output_contains "No git hook need to update or install."
}

@test "git-client-hook: install bats & bats-assert." {
  git init

  HOOK_TEST_FILE_NAMES=($(ls $HOOK_TEST_REPO_PATH))
  NODE_ENV="development" run git-client-hook.sh
  assert_output_contains "bats installing."
  assert_output_contains "bats installed."
  assert_output_contains "bats-assert installing."
  assert_output_contains "bats-assert installed."

  run git-client-hook.sh
  refute_output_contains "bats installing."
  refute_output_contains "bats installed."
  refute_output_contains "bats-assert installing."
  refute_output_contains "bats-assert installed."
}

@test "git-client-hook: failure if project not contains package.json." {
  git init

  rm "$HOOK_TEST_PATH/package.json"
  HOOK_TEST_FILE_NAMES=($(ls $HOOK_TEST_REPO_PATH))
  NODE_ENV="development" run git-client-hook.sh
  assert_failure  "Node project does not have package.json !"
}
