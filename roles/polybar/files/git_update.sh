#!/usr/bin/bash

notify-send -a "Git:" -u normal "Git repo's update started."

TIME_START=$(date +%s)
ansible-playbook ~/GIT/projects_home/_ansible-collection/ansible-git-control/playbook.yml
TIME_END=$(date +%s)

DIFF=$(( $TIME_END - $TIME_START ))
echo "It took $DIFF seconds"

TIME_DIFF=$(date -d@$DIFF -u +%H:%M:%S)

notify-send -a "Git:" -u normal "Update completed Time:[$TIME_DIFF]"

