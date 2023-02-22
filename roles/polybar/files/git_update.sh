#!/usr/bin/bash

notify-send -a "Git" -u normal "Git repo's update started."

TIME_START=$(date +%s)

ansible-playbook ~/GIT/projects_home/_ansible-collection/ansible-git-control/playbook.yml | tee $HOME/.ansible.git_control.log

TIME_END=$(date +%s)

# --------------------------------------------------------------------------

DIFF=$(( $TIME_END - $TIME_START ))
TIME_DIFF=$(date -d@$DIFF -u +%H:%M:%S)
LINE=$(cat $HOME/.ansible.git_control.log| grep "ok=")
RELEVANT=$(echo $LINE | awk '{print $3}' | awk -F '=' '{print $2}')
CHANGED=$(echo $LINE | awk '{print $4}' | awk -F '=' '{print $2}')
FAILED=$(echo $LINE | awk '{print $6}' | awk -F '=' '{print $2}')
SKIPPED=$(echo $LINE | awk '{print $7}' | awk -F '=' '{print $2}')

echo "It took $DIFF seconds"
notify-send -a "Git" -u normal "Repositories have been updated:

  Relevant: [$RELEVANT]
  Changed:  [$CHANGED]
  Failed:   [$FAILED]
  Skipped:  [$SKIPPED]

Time spent:[$TIME_DIFF]
"

