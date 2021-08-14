#!/bin/bash

# A simple script for preparing the environment for PlayBook running

read -sp "Please enter your sudo password: " PW ; echo


# --- Change mod for id_rsa -------------------------------------------------------------------------------------------
if [ -e $HOME/.ssh/id_rsa ]; then
  chmod 600 $HOME/.ssh/id_rsa
fi


# --- Make GIT directory ----------------------------------------------------------------------------------------------
if [ ! -d "$HOME/GIT" ]; then
  mkdir $HOME/GIT \
        $HOME/GIT/Projects_Home
fi


# --- Install yay (if not exist)  -------------------------------------------------------------------------------------
if ! [ -x "$(command -v yay)" ]; then
  yes | sudo pacman -S --needed yajl python3
  cd /tmp
  git clone https://aur.archlinux.org/yay-git.git && cd yay/
  makepkg -si
fi


# --- Install snap (if not exist)  ------------------------------------------------------------------------------------
if ! [ -x "$(command -v snap)" ]; then
  yes | yay -S --noconfirm --needed snapd
  sudo systemctl enable --now snapd.socket
  echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
  sudo ln -s /var/lib/snapd/snap /snap
fi
sudo ln -s /var/lib/snapd/snap /snap 2>/dev/null || true


# --- Install ansible (if not exist) ----------------------------------------------------------------------------------
if ! [ -x "$(command -v ansible)" ]; then
  yes | sudo -S pacman -S ansible
  yes | yay -S --noconfirm ansible-aur
  ansible-galaxy collection install community.general
fi


# --- Download Dotfiles from GitHub -----------------------------------------------------------------------------------
cd $HOME/GIT/Projects_Home/
git clone git@github.com:dvragulin/dotfiles-public.git 2>/dev/null || true
cd $HOME/GIT/Projects_Home/dotfiles-public


# --- Run Ansible playbook --------------------------------------------------------------------------------------------
ansible-playbook playbook.yml --extra-vars "ansible_sudo_pass=$PW"


# --- Change shell to ZSH ---------------------------------------------------------------------------------------------
echo $PW | chsh -s "$(which zsh)"


# --- Finaly ----------------------------------------------------------------------------------------------------------
echo
echo "Bootstrap complete. Successfully set up environment."
echo

