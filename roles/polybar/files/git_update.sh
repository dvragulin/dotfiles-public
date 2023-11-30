#!/usr/bin/bash

notify-send -a "Git:" -u normal "Git repo's update started."

NAME_HEADER=$(date -u +%Y%m%d%H%M%S)

TIME_START=$(date +%s)

ansible-playbook ~/GIT/projects_home/_ansible-collection/ansible-git-control/playbook.yml | tee $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log

TIME_END=$(date +%s)

# --------------------------------------------------------------------------

DIFF=$(( $TIME_END - $TIME_START ))
TIME_DIFF=$(date -d@$DIFF -u +%H:%M:%S)
LINE=$(cat $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log| grep "ok=")
RELEVANT=$(echo $LINE | awk '{print $3}' | awk -F '=' '{print $2}')
CHANGED=$(echo $LINE | awk '{print $4}' | awk -F '=' '{print $2}')
FAILED=$(echo $LINE | awk '{print $9}' | awk -F '=' '{print $2}')

echo "It took $DIFF seconds"
notify-send -a "Git" -u normal "Repositories have been updated:

  Relevant: [$RELEVANT]
  Changed:  [$CHANGED]
  Failed:   [$FAILED]

Time spent:[$TIME_DIFF]
"

rg FAIL -B 1 < $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log > $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.errors.log

echo "Relevant:  [$RELEVANT]" >> $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log
echo "Changed:   [$CHANGED]" >> $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log
echo "Failed:    [$FAILED]" >> $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log
echo "Time spent:[$TIME_DIFF]" >> $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log

