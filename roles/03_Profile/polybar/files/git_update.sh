#!/usr/bin/bash

echo -e "\e[0A\e[K\e[0;34m\ Collecting... \e[0m"
notify-send -a "Git:" -u normal "Git repo's collecting started."

RENEDER_STOPPER="false"
PRINT_REPOS_ANS="$1"

rm /tmp/git_update.sh.log 2>/dev/null || true

for i in `ls $HOME/GIT/`; do
  for x in `ls $HOME/GIT/$i`; do
    cd $HOME/GIT/$i/$x
    if [ $(git status --porcelain 2>/dev/null | wc -l) -eq "0" ]; then
      true
    else
      RENDER_ERROR="true"
      echo $HOME/GIT/$i/$x >> /tmp/git_update.sh.log
      REPOS=$((REPOS+1))
    fi
  done
done

if [[ "$RENDER_ERROR" == "true" && "$PRINT_REPOS_ANS" == "yes" ]]; then
  echo -e "\e[0A\e[K\e[0;32m\e[0m Information about $REPOS uncommited repositories was found:\n"
  cat /tmp/git_update.sh.log

  gum confirm "Do you want to continue?"

  if [ $? -eq 1 ]; then
    echo -e "\n\e[0;32m\e[0m Operation was canceled."
    exit 0
  fi

  echo -e "\n\n \033[33m 🏃\033[m Running playbook \n"
fi

notify-send -a "Git:" -u normal "Git repo's update started."

NAME_HEADER=$(date -u +%Y%m%d%H%M%S)

TIME_START=$(date +%s)

ansible-playbook ~/GIT/projects_home/ansible-git-control/playbook.yml | tee $HOME/tmp/ansible.git.conrtol.$NAME_HEADER.log

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
