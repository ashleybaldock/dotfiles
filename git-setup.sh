git config --global core.editor "/usr/local/bin/vim"
git config --global core.excludesfile "~/.gitignore"

git config --global alias.last 'log -1 HEAD'
git config --global alias.conflicts "diff --name-only --diff-filter=U"
git config --global alias.unstage 'reset HEAD --'
git config --global alias.change-commits "!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" $@; }; f "
git config --global alias.parent "!git show-branch | grep '*' | grep -v \"$(git rev-parse --abbrev-ref HEAD)\" | head -n1 | sed 's/.*\\[\\(.*\\)\\].*/\\1/' | sed 's/[\\^~].*//' #"

# Tidy
# git remote prune origin
# git checkout develop && git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d

# git change-commits GIT_AUTHOR_EMAIL "old@email.com" "new@email.com"
# git change-commits GIT_COMMITTER_EMAIL "old@email.com" "new@email.com" HEAD~10..HEAD

