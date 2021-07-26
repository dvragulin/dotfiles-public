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

set -e

if ! [ -x "$(command -v yay)" ]; then
  yes | sudo pacman -S --needed base-devel git yajl python3
  cd /tmp
  git clone https://aur.archlinux.org/yay.git && cd yay/
  makepkg -si
fi

if ! [ -x "$(command -v snap)" ]; then
  cd /tmp && git clone https://aur.archlinux.org/snapd.git
  cd snapd
  makepkg -si
  sudo systemctl enable --now snapd.socket
  sudo ln -s /var/lib/snapd/snap /snap
fi

if ! [ -x "$(command -v ansible)" ]; then
  yes | sudo -S pacman -S ansible
  yes | yay -Ss ansible-aur
  ansible-galaxy collection install community.general
fi

cd $HOME/GIT/Projects_Home/
git clone https://github.com/dvragulin/dotfiles-public.git
cd $HOME/GIT/Projects_Home/dotfiles-public

ansible-playbook playbook.yml --extra-vars "ansible_sudo_pass=$PW"

echo $PW | chsh -s $(which zsh)

echo
echo "Bootstrap complete. Successfully set up environment."

