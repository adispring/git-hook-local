#!/bin/sh

LOCAL_DIR=$(pwd)
HOOK_DIR=${LOCAL_DIR}/.git/hooks/
HOOK_REPO_DIR=${LOCAL_DIR}/git-hook/
CURRENT_FILE_NAME=$0
HOOK_FILE_NAMES=$(ls ${HOOK_REPO_DIR} | grep -E "\.hook$")

if [ ! -d "$HOOK_DIR" ]; then
  echo "No ${HOOK_DIR} exist!"
else
  echo "GIT LOCAL HOOK installing...! ⚙ "
  for hook_file in ${HOOK_FILE_NAMES}
  do
    file=${hook_file%.hook}
    if [ -f ${HOOK_DIR}${file} ]; then
      file_diff=$(diff ${HOOK_REPO_DIR}${hook_file} ${HOOK_DIR}${file})
      
      if [ -z "$file_diff" ]; then
        echo "${file} exists, and nothing changed."
      else
        echo -e "${file} has changed: \n${file_diff}"
        echo "${file} updating..."
        cp ${HOOK_REPO_DIR}${hook_file} ${HOOK_DIR}${file}
        echo "${file} updated!"
      fi
    else
      echo "${file} installing..."
      cp ${HOOK_REPO_DIR}${hook_file} ${HOOK_DIR}${file}
      echo "${file} installed!"
    fi
  done
  echo "GIT LOCAL HOOK install done!  🍻"
fi

exit 0
