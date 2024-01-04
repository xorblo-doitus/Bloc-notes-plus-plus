for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set branch=%%i

if %branch% == main echo Cannot rebase main on main. & exit 1


git stash push --include-untracked
git fetch
git pull origin
git push origin
git pull origin main
git push origin main
git checkout %branch%
git rebase 
git push --force
git stash pop