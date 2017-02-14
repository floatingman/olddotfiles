#!/bin/bash

remote=`git remote -v | awk '/\(push\)$/ {print $2}'`
email=will@itsananderson.com # default

if [[ $remote == *digitalreasoning* ]]; then
  email=daniel.newman@digitalreasoning.com
fi
if [[ $remote == *github.com:floatingman* ]]; then
  email=dwnewman78@gmail.com
fi

echo "Configuring user.email as $email"
git config user.email $email
