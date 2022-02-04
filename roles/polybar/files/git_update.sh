#!/usr/bin/bash

cd $HOME/GIT/

notify-send -a "Git Update started..." -u normal "Git repo's update started."

for i in `ls $HOME/GIT/`; do
  for x in `ls $HOME/GIT/$i`; do
    cd $HOME/GIT/$i/$x
    pwd
    git co master && git pull || true | 1>/dev/null
  done ;
done

 notify-send -a "Git Update" -u normal "Git repo's update completed."

