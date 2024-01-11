# Dotfiles

Personal Ansible roles for applying my dotfiles. 

#### Usage
```
bash -c "$(wget -O- https://raw.githubusercontent.com/dvragulin/dotfiles-public/master/bin/bootstrap.sh)"
```

### Roles


- [01_Init.yml](01_Init.yml)
    - install_applications
    - make_directories
    - make_links
- [02_Workstation.yml](02_Workstation.yml)
    - bluetooth
    - grub
    - keychron
    - ssh
    - sysctl
    - units
- [03_Profile.yml](03_Profile.yml)
    - avatars
    - bash
    - dunst
    - gtk
    - i3
    - polybar
    - rofi
    - wallpapers
    - xinit
    - zsh
- [04_Applications.yml](04_Applications.yml)
    - alacritty
    - btop
    - flameshot
    - git
    - glow
    - helix
    - k9s
    - lazygit
    - mc
    - newsboat
    - nvim
    - pacseek
    - pyradio
    - ranger
    - taskwarrior
    - tmux
    - vim
    - zathura