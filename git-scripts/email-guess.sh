#!/bin/bash
remote="$(git remote -v | awk '/\(push\)$/ {print $2}')"
email=dwnewman78@gmail.com # default
echo "$remote"
[[ $remote == *newyu* ]] && email=dnewman@newyu.com
[[ $remote == *digitalreasoning* ]] && email=daniel.newman@digitalreasoning.com
[[ $remote == *github.com:floatingman* ]] && email=dwnewman78@gmail.com

echo "Configuring user.email as $email"
git config user.email $email
