#!/bin/bash

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "main" ]]; then
	echo 'Cannot rebase main on main.';
	exit 1;
fi


git stash push --include-untracked
git rebase main
git stash pop