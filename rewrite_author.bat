@echo off
setlocal enabledelayedexpansion
set FILTER_BRANCH_SQUELCH_WARNING=1
git filter-branch -f --env-filter "if [ '$GIT_COMMITTER_NAME' = 'AI Assistant' ]; then export GIT_COMMITTER_NAME='dula-0816'; export GIT_COMMITTER_EMAIL='dulanmisasandula@gmail.com'; fi; if [ '$GIT_AUTHOR_NAME' = 'AI Assistant' ]; then export GIT_AUTHOR_NAME='dula-0816'; export GIT_AUTHOR_EMAIL='dulanmisasandula@gmail.com'; fi" -- --all
