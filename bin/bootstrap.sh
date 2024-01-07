#!/bin/bash

# A simple script for preparing the environment for PlayBook running

read -sp "[sudo] пароль для $USER: " PW ; echo


# --- Change mod for id_rsa -------------------------------------------------------------------------------------------
if [ -e $HOME/.ssh/id_rsa ]; then
  chmod 600 $HOME/.ssh/id_rsa
  echo "[INFO] Change mod for id_rsa"
fi


# --- Make GIT directory ----------------------------------------------------------------------------------------------
if [ ! -d "$HOME/GIT" ]; then
  mkdir $HOME/GIT \
        $HOME/GIT/projects_home
  echo "[INFO] Make GIT folder"
  echo "[INFO] Make GIT/projects_home folder"
fi


# --- Install yay (if not exist)  -------------------------------------------------------------------------------------
if ! [ -x "$(command -v yay)" ]; then
  sudo pacman-mirrors --fasttrack
  sudo pacman -Syyu
  sudo pacman -Syu yajl python3 base-devel
  cd /tmp
  git clone https://aur.archlinux.org/yay-git.git && cd yay-git/
  sleep 10
  makepkg -si
  echo "[INFO] yay installed"
fi


# --- Install snap (if not exist)  ------------------------------------------------------------------------------------
if ! [ -x "$(command -v snap)" ]; then
  yes | yay -S --noconfirm --needed snapd
  sudo systemctl enable --now snapd.socket
  echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
  sudo ln -s /var/lib/snapd/snap /snap
  echo "[INFO] Snap installed"
fi
sudo ln -s /var/lib/snapd/snap /snap 2>/dev/null || true


# --- Install ansible (if not exist) ----------------------------------------------------------------------------------
if ! [ -x "$(command -v ansible)" ]; then
  yes | sudo -S pacman -S ansible
  yes | yay -S --noconfirm ansible-aur
  ansible-galaxy collection install community.general
  echo "[INFO] Ansible installed"
fi


# --- Download Dotfiles from GitHub -----------------------------------------------------------------------------------
cd $HOME/GIT/projects_home/
git clone git@github.com:dvragulin/dotfiles-public.git 2>/dev/null || true
git clone git@github.com:dvragulin/common-scripts.git 2>/dev/null || true
cd $HOME/GIT/projects_home/dotfiles-public
echo "[INFO] Main git repositories updated"

# --- Run Ansible playbook --------------------------------------------------------------------------------------------
TIME_START=$(date +%s)
ansible-playbook playbook.yml --extra-vars "ansible_sudo_pass=$PW"
TIME_END=$(date +%s)

DIFF=$(( $TIME_END - $TIME_START ))
TIME_DIFF=$(date -d@$DIFF -u +%H:%M:%S)

  echo "[INFO] Ansible playbook comoleted"
# --- Run go for intall custom apps -----------------------------------------------------------------------------------
sudo systemctl enable fstrim.timer
sudo systemctl enable ananicy.service || true
sudo systemctl enable cpupower.service || true
sudo systemctl enable cpupower-gui.service || true
sudo systemctl enable haveged || true
sudo systemctl enable --now dbus-broker.service || true
sudo systemctl mask NetworkManager-wait-online.service
echo "[INFO] systemctl configured"


# --- Run go for intall custom apps -----------------------------------------------------------------------------------
#go install github.com/fedeztk/got/cmd/got@latest
#sudo gpasswd -a $USER docker
#sudo systemctl start docker
#sudo chmod 666 /var/run/docker.sock


# --- Change shell to ZSH ---------------------------------------------------------------------------------------------
echo $PW | chsh -s "$(which zsh)"
echo "[INFO] zsh was choosen"


# --- Finaly ----------------------------------------------------------------------------------------------------------
git home
echo "[INFO] Git home configuratuin was aplied"
echo "[INFO] Bootstrap complete. Successfully set up environment Time:[$TIME_DIFF]"
