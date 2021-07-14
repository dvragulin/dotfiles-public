# Vim commands after update

После сборки необходимо выполнить следующие команды: 

Inside VIM

    :source ~/.vimrc
    :PlugInstall

inside shell

    cd .vim/plugged/YouCompleteMe
    ./install.py --clang-completer --gocode-completer

