#!/bin/bash

read -sp "Please enter your sudo password: " PW

mkdir $HOME/GIT \
      $HOME/GIT/Projects_Home \
      $HOME/GIT/Projects_Personal \
      $HOME/GIT/Projects_Tests \
      $HOME/GIT/Projects_OpenSource \
      $HOME/.tmux \
      $HOME/.config/rofi \
      $HOME/.config/zathura \
      $HOME/.vim \
      $HOME/.vim/autoload

cd $HOME/GIT/Projects_Home/

git clone git@github.com:dvragulin/dotfiles-public.git 

cd dotfiles-public

if ! [ -x "$(command -v ansible)" ]; then
  yes | sudo -S pacman -S ansible
  yes | sudo -S pamac install ansible-aur-git
  ansible-galaxy collection install community.general
fi

ansible-playbook playbook.yml --extra-vars "ansible_sudo_pass=$PW"

echo $PW | chsh -s $(which zsh)

echo
echo "Bootstrap complete. Successfully set up environment."

