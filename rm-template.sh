#!/usr/bin/env bash

# https://github.com/panozzaj/conf/blob/master/common/bin/git-submodule-remove

source vars.sh

src="templates/$TEMPLATE"

[ -d "$src" ] || (echo "$src not found" && exit 1)

# Remove the submodule entry from .git/config
echo "Deinitializing submodule $src"
git submodule deinit -f $src

# Remove the submodule directory from the superproject's .git/modules directory
echo "Removing .git/modules for $src"
rm -rf .git/modules/$src

# Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
echo "Removing files for $src"
git rm -rf $src
