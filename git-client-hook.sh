#!/bin/sh

# TODO: let install script more general to use.
hook_dir="./.git/hooks"
prepush_hook_file="./.git/hooks/pre-push"
prepush_local_file="./git-hook/pre-push"

if [ -d "$hook_dir" -a ! -f "$prepush_hook_file" -a -f "$prepush_local_file" ]
then
  cp "$prepush_local_file" "$prepush_hook_file"
  echo ".git/hooks/pre-push install sucess!"
else
  echo ".git/hooks/pre-push exist!"
fi

exit 0
