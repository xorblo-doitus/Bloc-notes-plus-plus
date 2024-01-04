git fetch

for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set branch=%%i

if %branch% == main echo Cannot rebase main on main. & exit 1

echo oups

git stash push --include-untracked
git rebase main
git stash pop