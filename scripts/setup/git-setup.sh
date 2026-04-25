#!/usr/bin/env bash

echo "Setting up global .gitconfig" >&2

name_conf=$(git config --global user.name)
name_auto=$USER
confemail=$(git config --global user.email)

echo "Info pls?" >&2
read -p "git:user.name: ($confname)" -a name
read -p "git:user.email: ($confemail)" email


git config --global include.path = "~/dotfiles/.gitconfig/.gitconfig"
git config --global include.path = "~/dotfiles/.gitconfig/color.gitconfig"
git config --global include.path = "~/dotfiles/.gitconfig/alias.gitconfig"
git config --global include.path = "~/dotfiles/.gitconfig/delta.gitconfig"

git config --global user.name = "$name"
git config --global user.email = "$email"
