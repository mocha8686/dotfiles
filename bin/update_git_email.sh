#!/bin/bash
git rebase -r --root --exec "git commit --amend --no-edit --reset-author"
