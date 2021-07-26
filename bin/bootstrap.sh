#!/bin/bash

read -sp "Please enter your sudo password: " PW

mkdir $HOME/GIT \
      $HOME/GIT/Projects_Home \
      $HOME/GIT/Projects_Personal \
      $HOME/GIT/Projects_Tests \
      $HOME/GIT/Projects_OpenSource \
      $HOME/.config \
      $HOME/.tmux \
      $HOME/.config/rofi \
      $HOME/.config/zathura \
      $HOME/.vim \
      $HOME/.vim/autoload

#if ! [ -x "$(command -v pamac)" ]; then
yes | sudo pacman -S --needed base-devel yajl
cd /tmp
git clone https://aur.archlinux.org/package-query.git
cd package-query/
makepkg -si && cd /tmp/
git clone https://aur.archlinux.org/yaourt.git
cd yaourt/
makepkg -si
yaourt -S pamac-aur && cd /tmp/
git clone	https://aur.archlinux.org/ansible-aur-git.git
cd ansible-aur-git/
makepkg -si
#fi

if ! [ -x "$(command -v ansible)" ]; then
  yes | sudo -S pacman -S ansible
  ansible-galaxy collection install community.general
fi

cd $HOME/GIT/Projects_Home/
git clone https://github.com/dvragulin/dotfiles-public.git
cd $HOME/GIT/Projects_Home/dotfiles-public

ansible-playbook playbook.yml --extra-vars "ansible_sudo_pass=$PW"

echo $PW | chsh -s $(which zsh)

echo
echo "Bootstrap complete. Successfully set up environment."

