#!/bin/bash

mkdir $HOME/GIT \
      $HOME/GIT/Projects_Home \
      $HOME/GIT/Projects_Personal \
      $HOME/GIT/Projects_Tests \
      $HOME/GIT/Projects_OpenSource

cd $HOME/GIT/Projects_Home/

git clone git@github.com:dvragulin/dotfiles-public.git 

cd dotfiles-public

ansible-playbook playbook.yml --extra-vars "ansible_sudo_pass=$1"

