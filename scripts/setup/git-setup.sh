
git config --global alias.last 'log -1 HEAD'
git config --global alias.conflicts "diff --name-only --diff-filter=U"
git config --global alias.unstage 'reset HEAD --'
git config --global alias.change-commits "!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" $@; }; f "
git config --global alias.parent "!git show-branch | grep '*' | grep -v \"$(git rev-parse --abbrev-ref HEAD)\" | head -n1 | sed 's/.*\\[\\(.*\\)\\].*/\\1/' | sed 's/[\\^~].*//' #"

git config --global core.excludesfile "~/.gitignore"
git config --global core.editor "vim"
git config --global core.pager "delta"

git config --global user.useConfigOnly true
git config --global delta.features "decorations"

git config --global delta.interactive.keep-plus-minus-marker "false"

git config --global delta.decorations.commit-decoration-style "blue ol"
git config --global delta.decorations.commit-style "raw"
git config --global delta.decorations.file-style "omit"
git config --global delta.decorations.hunk-header-decoration-style "blue box"
git config --global delta.decorations.hunk-header-file-style "red"
git config --global delta.decorations.hunk-header-line-number-style "#067a00"
git config --global delta.decorations.hunk-header-style "file line-number syntax"

git config --global interactive.diffFilter "delta --color-only --features=interactive"

# Tidy
# git remote prune origin
# git checkout develop && git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

# git change-commits GIT_AUTHOR_EMAIL "old@email.com" "new@email.com"
# git change-commits GIT_COMMITTER_EMAIL "old@email.com" "new@email.com" HEAD~10..HEAD


git config --global color.status.header = "244"
git config --global color.status.untracked = "9"
git config --global color.status.changed = "78"
git config --global color.status.changed = "220"
git config --global color.status.updated = "117"
git config --global color.status.added = "48"
git config --global color.status.branch = "86"
git config --global color.status.localBranch = "86"
git config --global color.status.remoteBranch = "219"

git config --global color.branch.local    = "159"
git config --global color.branch.remote   = "219"
git config --global color.branch.upstream = "21"
git config --global color.branch.plain    = "250"
git config --global color.branch.current  = "14"

git config --global color.push.error = "203"

git config --global color.transport.rejected = "203"

git config --global color.remote.hint = "68"
git config --global color.remote.warning = "214"
git config --global color.remote.success = "118"
git config --global color.remote.error = "203"

git config --global log.graphColors = "160,161,162,163,164,165,196,197,198,199,200,201"
