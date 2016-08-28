#!/bin/sh

LOCAL_DIR=$(pwd)
HOOK_DIR=${LOCAL_DIR}/.git/hooks/
HOOK_REPO_DIR=${LOCAL_DIR}/git-hook/
CURRENT_FILE_NAME=$0
HOOK_FILE_NAMES=$(ls ${HOOK_REPO_DIR} | grep -E "\.hook$")

if [ ! -d "$HOOK_DIR" ]; then
  echo "No ${HOOK_DIR} exist!"
else
  ALL_HOOKS=()
  EXIST_HOOKS=()
  UPDATE_HOOKS=()
  INSTALL_HOOKS=()
  for hook_file in ${HOOK_FILE_NAMES}
  do
    ALL_HOOKS[${#ALL_HOOKS[@]}]=${hook_file}
    file=${hook_file%.hook}
    if [ -f ${HOOK_DIR}${file} ]; then
      file_diff=$(diff ${HOOK_REPO_DIR}${hook_file} ${HOOK_DIR}${file})
      
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
        file_diff=$(diff ${HOOK_REPO_DIR}${hook_file} ${HOOK_DIR}${file})
        echo -e "${file} has changed: \n${file_diff}"
        echo "${file} updating..."
        cp ${HOOK_REPO_DIR}${hook_file} ${HOOK_DIR}${file}
        echo -e "${file} updated!\n"
       done
    fi
    if [ ${#INSTALL_HOOKS[@]} -gt 0 ]; then
      for hook_file in ${INSTALL_HOOKS}
      do
        file=${hook_file%.hook}
        echo "${file} installing..."
        cp ${HOOK_REPO_DIR}${hook_file} ${HOOK_DIR}${file}
        echo -e "${file} intsalled!\n"
       done
    fi
    echo "GIT LOCAL HOOK install done!  🍻"
  fi 
fi
