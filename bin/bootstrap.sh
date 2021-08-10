#!/bin/bash

read -sp "Please enter your sudo password: " PW
set -e

if [ ! -d "$HOME/GIT" ]; then
  mkdir $HOME/GIT \
        $HOME/GIT/Projects_Home \
fi

# --- Install yay (if not exist)  -------------------------------------------------------------------------------------

if ! [ -x "$(command -v yay)" ]; then
  yes | sudo pacman -S --needed base-devel yajl python3
  cd /tmp
  git clone https://aur.archlinux.org/yay.git && cd yay/
  makepkg -si
fi

# --- Install snap (if not exist)  ------------------------------------------------------------------------------------

if ! [ -x "$(command -v snap)" ]; then
  yes | yay -S --noconfirm --needed snapd
  sudo systemctl enable --now snapd.socket
  sudo ln -s /var/lib/snapd/snap /snap
  echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
fi

# --- Install ansible (if not exist) ----------------------------------------------------------------------------------

if ! [ -x "$(command -v ansible)" ]; then
  yes | sudo -S pacman -S ansible
  yes | yay -S --noconfirm ansible-aur
  ansible-galaxy collection install community.general
fi

# --- Run playbook ---------------------------------------------------------------------------------------------------
cd $HOME/GIT/Projects_Home/
git clone git@github.com:dvragulin/dotfiles-public.git
cd $HOME/GIT/Projects_Home/dotfiles-public

ansible-playbook playbook.yml --extra-vars "ansible_sudo_pass=$PW"

# --- Finaly ----- ---------------------------------------------------------------------------------------------------

echo $PW | chsh -s "$(which zsh)"

echo
echo "Bootstrap complete. Successfully set up environment."
echo

