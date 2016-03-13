#!/usr/bin/env bash

# DO NOT EDIT. This file generated by pkg/bin/generate-help-functions.pl.

set -e

help:all() {
    cat <<'...'
branch               branch <subdir>|--all
clean                clean <subdir>|--all
clone                clone <repository> [<subdir>] [-b <upstream-branch>] [-f]
commit               commit <subdir> [<subrepo-ref>]
fetch                fetch <subdir>|--all
help                 help
init                 init <subdir> [-r <remote>] [-b <branch>]
merge-base           merge-base <branch1> <branch2>
pull                 pull <subdir>|--all [-b <branch>] [-r <remote>] [-u]
push                 push <subdir>|--all [<branch>] [-r <remote>] [-b <branch>] [-u]
status               status [<subdir>]
version              version [--verbose] [--quiet]
...
}

help:branch() {
    cat <<'...'

  Usage: git subrepo branch <subdir>|--all


  Create a branch with local subrepo commits.

  Scan the history of the mainline for all the commits that affect the
  `subdir` and create a new branch from them called `subrepo/<subdir>`.

  This is useful for doing `pull` and `push` commands by hand.

  Use the `--force` option to write over an existing `subrepo/<subdir>`
  branch.

  The `branch` command accepts the `--all` and `--force` options.
...
}

help:clean() {
    cat <<'...'

  Usage: git subrepo clean <subdir>|--all


  Remove artifacts created by `fetch` and `branch` commands.

  The `fetch` and `branch` operations (and other commands that call them)
  create temporary things like refs, branches and remotes. This command
  removes all those things.

  Use `--force` to remove refs. Refs are not removed by default because they
  are sometimes needed between commands. To remove all subrepo artifacts:

    git subrepo clean --all --force

  The `clean` command takes the `--all` and `--force` options.
...
}

help:clone() {
    cat <<'...'

  Usage: git subrepo clone <repository> [<subdir>] [-b <upstream-branch>] [-f]


  Add a repository as a subrepo in a subdir of your repository.

  This is similar in feel to `git clone`. You just specify the remote repo
  url, and optionally a sub-directory and/or branch name. The repo will be
  fetched and merged into the subdir.

  The subrepo history is /squashed/ into a single commit that contains the
  reference information. This information is also stored in a special file
  called `<subdir>/.gitrepo`. The presence of this file indicates that the
  directory is a subrepo.

  All subsequent commands refer to the subrepo by the name of the /subdir/.
  From the subdir, all the current information about the subrepo can be
  obtained.

  The `--force` option will "reclone" (completely replace) an existing subdir.

  The `clone` command accepts the `--branch=` and `--force` options.
...
}

help:commit() {
    cat <<'...'

  Usage: git subrepo commit <subdir> [<subrepo-ref>]


  Add subrepo branch to current history as a single commit.

  This command is generally used after a hand-merge. You have done a `subrepo
  branch` and merged (rebased) it with the upstream. This command takes the
  HEAD of that branch, puts its content into the subrepo subdir and adds a new
  commit for it to the top of your mainline history.

  This command requires that the upstream HEAD be in the `subrepo/<subdir>`
  branch history. That way the same branch can push upstream. Use the
  `--force` option to commit anyway.

  The `commit` command accepts the `--force` option.
...
}

help:fetch() {
    cat <<'...'

  Usage: git subrepo fetch <subdir>|--all


  Fetch the remote/upstream content for a subrepo.

  It will create a Git reference called `subrepo/<subdir>/fetch` that
  points at the same commit as `FETCH_HEAD`. It will also create a remote
  called `subrepo/<subdir>`. These are temporary and you can remove them
  easily with the subrepo `clean` command.

  The `fetch` command accepts the `--all`, `--branch=` and `--remote=`
  options.
...
}

help:help() {
    cat <<'...'

  Usage: git subrepo help


  Same as `git help subrepo`. Will launch the manpage. For the shorter usage,
  use `git subrepo -h`.
...
}

help:init() {
    cat <<'...'

  Usage: git subrepo init <subdir> [-r <remote>] [-b <branch>]


  Turn an existing subdirectory into a subrepo.

  If you want to expose a subdirectory of your project as a published subrepo,
  this command will do that. It will split out the content of a normal
  subdirectory into a branch and start tracking it as a subrepo. Afterwards
  your original repo will look exactly the same except that there will be a
  `<subdir>/.gitrepo` file.

  If you specify the `--remote` (and optionally the `--branch`) option, the
  values will be added to the `<subdir>/.gitrepo` file. The `--remote` option
  is the upstream URL, and the `--branch` option is the upstream branch to
  push to. These values will be needed to do a `git subrepo push` command, but
  they can be provided later on the `push` command (and saved to
  `<subdir>/.gitrepo` if you also specify the `--update` option).

  Note: You will need to create the empty upstream repo and push to it on your
  own, using `git subrepo push <subdir>`.

  The `init` command accepts the `--branch=` and `--remote=` options.
...
}

help:merge-base() {
    cat <<'...'

  Usage: git subrepo merge-base <branch1> <branch2>


  This "plumbing" command finds a common ancestor between two branches. It will
  look at the referenced tree hash in the commits to see if it can locate a
  common one.

  This is used for pull and push before the rebase step. In this case we look
  at all the local commits and then try to find a tree hash that is available
  in the subrepo.

  Note: This is different from the `git merge-base` command which looks at the
  object structure.

  Use the `--all` option to list all possible common ancestors. (This differs
  from other commands which use `--all` to apply the same command to all
  subrepos).

  The `merge-base` command accepts the `--all` option.
...
}

help:pull() {
    cat <<'...'

  Usage: git subrepo pull <subdir>|--all [-b <branch>] [-r <remote>] [-u]


  Update the subrepo subdir with the latest upstream changes.

  The `pull` command will attempt to do the following commands in one go:

    git subrepo fetch <subdir>
    git subrepo branch <subdir>
    git subrepo merge-base subrepo/<subdir>/fetch subrepo/<subdir>
    git rebase --onto <new_parent> <old_parent> subrepo/<subdir>
    git rebase subrepo/<subdir>/fetch subrepo/<subdir>
    git checkout ORIG_HEAD
    git subrepo commit <subdir>

  In other words, you could do all the above commands yourself, for the same
  effect. If any of the commands fail, subrepo will stop and tell you to
  finish this by hand. Generally a failure would be in the rebase, where
  conflicts can happen. Since Git has lots of ways to resolve conflicts to
  your personal tastes, the subrepo command defers to letting you do this by
  hand.

  Like the `clone` command, `pull` will squash all the changes (since the last
  pull or clone) into one commit. This keeps your mainline history nice and
  clean. You can easily see the subrepo's history with the `git log` command:

    git log refs/subrepo/<subdir>/fetch

  The set of commands used above are described in detail below.

  The `pull` command accepts the `--all`, `--branch=`, `--remote=` and
  `--update` options.
...
}

help:push() {
    cat <<'...'

  Usage: git subrepo push <subdir>|--all [<branch>] [-r <remote>] [-b <branch>] [-u]


  Push a properly merged subrepo branch back upstream.

  The `push` command requires a branch that has been properly merged/rebased
  with the upstream HEAD (unless the upstream HEAD is empty, which is common
  when doing a first `push` after an `init`). That means the upstream HEAD is
  one of the commits in the branch. If you don't specify a branch to push, one
  will be created for you using the same techniques as a pull (except it won't
  be committed locally). Otherwise you can name a properly merged branch to
  push. Often times you can use the branch commit from the last pull, which is
  saved as `refs/subrepo/<subdir>/pull`.

  After that, the `push` command just checks that the branch contains the
  upstream HEAD and then pushes it upstream.

  The `--force` option will do a force push. Force pushes are typically
  discouraged. Only use this option if you fully understand it. (The `--force`
  option will NOT check for a proper merge. ANY branch will be force pushed!)

  The `push` command accepts the `--all`, `--branch=`, `--force`, `--remote=`
  and `--update` options.
...
}

help:status() {
    cat <<'...'

  Usage: git subrepo status [<subdir>]


  Get the status of a subrepo. Show the status of all subrepos by default. If
  the `--quiet` flag is used, just print the subrepo names, one per line.

  The `--verbose` option will show all the recent local and upstream commits.

  The `status` command accepts the `--fetch` option.
...
}

help:version() {
    cat <<'...'

  Usage: git subrepo version [--verbose] [--quiet]


  This command will display version information about git-subrepo and its
  environment. For just the version number, use `git subrepo --version`. Use
  `--verbose` for more version info, and `--quiet` for less.
...
}

# vim: set sw=2 lisp:
