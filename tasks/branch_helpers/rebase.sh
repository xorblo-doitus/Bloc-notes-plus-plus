#!/bin/bash

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "main" ]]; then
	echo 'Cannot rebase main on main.';
	exit 1;
fi


git stash push --include-untracked
git fetch
git pull origin
git push origin
git pull origin main
git push origin main
git checkout $BRANCH
git rebase main
git push --force
git stash pop