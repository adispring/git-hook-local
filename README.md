# git-hook-local

## pre-push 文件作用：
An example hook script to verify what is about to be pushed.  Called by "git
push" after it has checked the remote status, but before anything has been
pushed.  If this script exits with a non-zero status nothing will be pushed.

在git push 之前做 npm test 检查，只有通过检查，才允许push

### 使用：
将此文件放置到项目中的 .git/hooks 文件夹下即可生效。

### todo：
1. npm test 输出信息彩色化
2. 也可以做TASK号的检查

