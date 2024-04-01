#!/bin/bash

info() {
  echo -e "\033[32m ✔\033[m $1"
}

TIME_START=$(date +%s)
SSH_KEY="$HOME/.ssh/id_rsa"
GIT_DIR="$HOME/GIT/projects_home"
REPOS=("dotfiles-public" "common-scripts")
CURRENT_SHELL=$(basename "$SHELL")

cat << "EOF"
 _                 _       _
| |__   ___   ___ | |_ ___| |_ _ __ __ _ _ __
| '_ \ / _ \ / _ \| __/ __| __| '__/ _` | '_ \
| |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) |
|_.__/ \___/ \___/ \__|___/\__|_|  \__,_| .__/
                                        |_|

EOF
read -sp "🗝 Please enter the sudo password for $USER: " PW ; echo

# --- Change mod for id_rsa -------------------------------------------------------------------------------------------
if [ -e "$SSH_KEY" ]; then
  chmod 600 "$SSH_KEY"
  info "Updated: id_rsa"
fi

# --- Make GIT directory ----------------------------------------------------------------------------------------------
if [ ! -d "$HOME/GIT" ]; then
  mkdir $HOME/GIT \
        $HOME/GIT/projects_home
  info "Updated: ./GIT"
  info "Updated: ./GIT/projects_home"
fi

# --- Install yay (if not exist)  -------------------------------------------------------------------------------------
if ! [ -x "$(command -v yay)" ]; then
  echo $PW | sudo -S pacman-mirrors --fasttrack
  echo $PW | sudo -S pacman -Syyu
  echo $PW | sudo -S pacman -Syu yajl python3 base-devel
  cd /tmp
  git clone https://aur.archlinux.org/yay-git.git && cd yay-git/
  sleep 10
  makepkg -si
  info "Updated: yay"
fi


# --- Install snap (if not exist)  ------------------------------------------------------------------------------------
if ! [ -x "$(command -v snap)" ]; then
  yes | yay -S --noconfirm --needed snapd
  echo $PW | sudo -S systemctl enable --now snapd.socket
  echo "export PATH=\$PATH:\/snap/bin/" | sudo tee -a /etc/profile
  echo $PW | sudo -S ln -s /var/lib/snapd/snap /snap
  info "Updated: snap"
fi
echo $PW | sudo -S ln -s /var/lib/snapd/snap /snap 2>/dev/null || true


# --- Install ansible (if not exist) ----------------------------------------------------------------------------------
if ! [ -x "$(command -v ansible)" ]; then
  echo $PW | sudo -S pacman -S  --noconfirm ansible
  yes | yay -S --noconfirm ansible-aur
  ansible-galaxy collection install community.general
  info "Updated: ansible"
fi
# --- Download Dotfiles from GitHub -----------------------------------------------------------------------------------
cd $HOME/GIT/projects_home/
git clone git@github.com:dvragulin/dotfiles-public.git 2>/dev/null || true
git clone git@github.com:dvragulin/common-scripts.git 2>/dev/null || true
cd $HOME/GIT/projects_home/dotfiles-public
info "Updated: dvragulin/dotfiles-public.git"
info "Updated: dvragulin/common-scripts.git"

# --- Run Ansible playbook --------------------------------------------------------------------------------------------
export ANSIBLE_CONFIG="./bin/ansible.cfg"
playbooks=($(/bin/ls *.yml))
selected_playbooks=()
if [ ${#playbooks[@]} -eq 0 ]; then echo "No available playbooks found."; exit 1; fi
printf "\nSelect the playbook(s) you want to run (e.g., 1 2 3):\n"
for i in "${!playbooks[@]}"; do
    echo "  $(($i + 1))) ${playbooks[$i]}"
done
read -p "Enter your choice(s): " -a choices
for choice in "${choices[@]}"; do
    index=$(($choice - 1))
    if [[ $index -ge 0 && $index -lt ${#playbooks[@]} ]]; then
        selected_playbooks+=("${playbooks[$index]}")
    else
        echo "Invalid selection: $choice"
        exit 1
    fi
done
echo
for playbook in "${selected_playbooks[@]}"; do
    printf "%0.s_" $(seq 1 $COLUMNS)
    echo -e "\n\n \033[33m 🏃\033[m Running playbook: \033[33m $playbook \033[m"
    printf "%0.s_" $(seq 1 $COLUMNS); printf "\n"
    ansible-playbook "$playbook" -e "ansible_sudo_pass=$PW"
done

# --- Enable system services ------------------------------------------------------------------------------------------
echo
echo $PW | sudo -S gpasswd -a $USER docker 1> /dev/null
info "Updated: gpasswd for $USER -> docker"
echo $PW | sudo -S chmod 666 /var/run/docker.sock
info "Updated: docker.sock"
SERVICES_TO_ENABLE=("docker"
                    "fstrim.timer"
                    "ananicy.service"
                    "cpupower.service"
                    "cpupower-gui.service"
                    "haveged"
                    "power-profiles-daemon"
                    "bluetooth.service")
for svc in "${SERVICES_TO_ENABLE[@]}"; do
  echo $PW | sudo -S systemctl enable --now "$svc" || true
  info "systemctl enabled: $svc"
done
echo $PW | sudo -S systemctl start docker
info "systemctl start: docker"
#sudo systemctl mask NetworkManager-wait-online.service || true

# Help for CPU 400mhz
# sudo rmmod intel_rapl_msr
# sudo modprobe intel_rapl_msr

# --- Change shell to ZSH ---------------------------------------------------------------------------------------------
if [ "$CURRENT_SHELL" != "zsh" ]; then echo $PW | chsh -s "$(which zsh)"; fi
info "Updated: default shell"
git home 1> /dev/null
info "Updated: git config"

# --- Final message ---------------------------------------------------------------------------------------------------
TIME_END=$(date +%s)
DIFF=$(( $TIME_END - $TIME_START ))
TIME_DIFF=$(date -d@$DIFF -u +%H:%M:%S)
info "Bootstrap complete. Successfully set up environment in Time: \033[32m[$TIME_DIFF]\033[m "
