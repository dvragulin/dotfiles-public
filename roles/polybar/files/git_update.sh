#!/usr/bin/bash

cd $HOME/GIT/

notify-send -a "Git:" -u normal "Git repo's update started."

ansible-playbook ~/GIT/projects_home/_ansible-collection/ansible-git-control/playbook.yml

# for i in `ls $HOME/GIT/`; do
#   for x in `ls $HOME/GIT/$i`; do
#     cd $HOME/GIT/$i/$x
#     echo
#     echo " -----------------------------------------------------------------------------------"
#     echo " $(pwd)"
#     echo
#     git co master && git pull || true | 1>/dev/null
#     echo
#     sleep 5
#   done ;
# done

notify-send -a "Git:" -u normal "Git repo's update completed."

