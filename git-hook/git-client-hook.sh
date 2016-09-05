#!/bin/sh

PROJECT_PATH=$(pwd)
GIT_HOOK_PATH=${PROJECT_PATH}/.git/hooks/
CUSTOM_HOOK_PATH=${PROJECT_PATH}/git-hook/hooks/
HOOK_FILE_NAMES=$(ls ${CUSTOM_HOOK_PATH} | grep -E "\.hook$")

is_node_env_dev() {
  node_env=$1
  if [ -n "$node_env" -a "$node_env" != "development" ]; then
    echo "No need to install git-hook in NODE_ENV: ${node_env}."
    exit 0
  fi
}

has_git_hooks_path() {
  git_hook_path=$1
  if [ ! -d "$git_hook_path" ]; then
    echo "No ${git_hook_path} exist!"
    exit 0
  fi
}

is_node_env_dev $NODE_ENV
has_git_hooks_path $GIT_HOOK_PATH

ALL_HOOKS=()
EXIST_HOOKS=()
UPDATE_HOOKS=()
INSTALL_HOOKS=()
for hook_file in ${HOOK_FILE_NAMES}
do
  ALL_HOOKS[${#ALL_HOOKS[@]}]=${hook_file}
  file=${hook_file%.hook}
  if [ -f ${GIT_HOOK_PATH}${file} ]; then
    file_diff=$(diff ${CUSTOM_HOOK_PATH}${hook_file} ${GIT_HOOK_PATH}${file})
    
    if [ -z "$file_diff" ]; then
      EXIST_HOOKS[${#EXIST_HOOKS[@]}]=${hook_file}
    else
      UPDATE_HOOKS[${#UPDATE_HOOKS[@]}]=${hook_file}
    fi
  else
    INSTALL_HOOKS[${#INSTALL_HOOKS[@]}]=${hook_file}
  fi
done

if [ ${#EXIST_HOOKS[@]} -eq ${#ALL_HOOKS[@]} ]; then
  echo "No git hook need to update or install."
else
  echo -e "GIT LOCAL HOOK installing...! ⚙ \n"
  if [ ${#UPDATE_HOOKS[@]} -gt 0 ]; then
    for hook_file in ${UPDATE_HOOKS}
    do
      file=${hook_file%.hook}
      file_diff=$(diff ${CUSTOM_HOOK_PATH}${hook_file} ${GIT_HOOK_PATH}${file})
      echo -e "${file} has changed: \n${file_diff}"
      echo "${file} updating..."
      cp ${CUSTOM_HOOK_PATH}${hook_file} ${GIT_HOOK_PATH}${file}
      echo -e "${file} updated!\n"
     done
  fi
  if [ ${#INSTALL_HOOKS[@]} -gt 0 ]; then
    for hook_file in ${INSTALL_HOOKS}
    do
      file=${hook_file%.hook}
      echo "${file} installing..."
      cp ${CUSTOM_HOOK_PATH}${hook_file} ${GIT_HOOK_PATH}${file}
      echo -e "${file} intsalled!\n"
     done
  fi
  echo "GIT LOCAL HOOK install done!  🍻"
fi 

