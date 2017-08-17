#!/usr/bin/env bash

set -e

source test/setup

use Test::More

clone-foo-and-bar

subrepo-clone-bar-into-foo

before="$(date -r $OWNER/foo/Foo '+%s')"

(
  cd $OWNER/foo
  add-new-files bar/file
  add-new-files .gitrepo
)

save-original-state $OWNER/foo bar

is "$(
  cd $OWNER/foo
  git subrepo branch bar
)" \
  "Created branch 'subrepo/bar' and worktree '.git/tmp/subrepo/bar'." \
  "subrepo branch command output is correct"

sleep 1
after="$(date -r $OWNER/foo/Foo '+%s')"
assert-original-state $OWNER/foo bar

is "$before" "$after" \
  "No modification on Foo"

test-exists "$OWNER/foo/.git/tmp/subrepo/bar/"

is "$(
  cd $OWNER/foo/.git/tmp/subrepo/bar
  git branch | grep \*
)" \
  "* subrepo/bar" \
  "Correct branch is checked out"

done_testing

teardown
