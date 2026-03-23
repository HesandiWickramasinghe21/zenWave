#!/usr/bin/env python3
import subprocess
import os

os.chdir(r'C:\Zenwave backend')

# Set environment variable
os.environ['FILTER_BRANCH_SQUELCH_WARNING'] = '1'

# Build the filter command as a string that bash will understand
filter_cmd = '''if [ "$GIT_AUTHOR_NAME" = "AI Assistant" ]; then
    export GIT_AUTHOR_NAME="dula-0816"
    export GIT_AUTHOR_EMAIL="dulanmisasandula@gmail.com"
fi
if [ "$GIT_COMMITTER_NAME" = "AI Assistant" ]; then
    export GIT_COMMITTER_NAME="dula-0816"
    export GIT_COMMITTER_EMAIL="dulanmisasandula@gmail.com"
fi'''

# Run git filter-branch
cmd = [
    'C:\\Program Files\\Git\\bin\\bash.exe',
    '-c',
    f'cd "C:/Zenwave backend" && git filter-branch -f --env-filter \'{filter_cmd}\' -- --all'
]

proc = subprocess.run(cmd, capture_output=True, text=True)
print("STDOUT:")
print(proc.stdout)
print("\nSTDERR:")
print(proc.stderr)
print(f"\nReturn code: {proc.returncode}")
