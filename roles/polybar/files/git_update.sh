#!/usr/bin/bash

cd $HOME/GIT/

notify-send -a "Git:" -u normal "Git repo's update started."

for i in `ls $HOME/GIT/`; do
  for x in `ls $HOME/GIT/$i`; do
    cd $HOME/GIT/$i/$x
    echo
    echo "-----------------------------------------------------------------------"
    pwd
    echo
    git co master && git pull || true | 1>/dev/null
    sleep 10
  done ;
done

 notify-send -a "Git:" -u normal "Git repo's update completed."

