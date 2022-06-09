#!/usr/bin/env bash

# Get the project for the task
project=$(task _unique project | fzf --prompt="Project: ")
clear

## Get all tags to be added to the task with fzf --multi
#tags=$(task _unique tags | fzf --multi --prompt="Tags: ")
##tags=$(echo "$tags" | sed 's/^/+/;s/\ /\ +/')
#tags=$(echo "$tags" | sed 's/^/+/;s/\ /\')
#clear

# Get duedate if ther is one
echo "What is the due date? Today? y/n"
read -r due_response

case "$due_response" in
    [yY]) duedate="eod";;
    #[yY]) duedate=$(date --rfc-3339=seconds | awk '{print $1}') ;;
    [nN]) clear && echo "Enter date as 'YYYY-MM-DD or +#[ymd]'" && read -r duedate ;;
    *) duedate="" ;;
esac
clear

# Get the name of the task
echo "What is the name of this task?"
read -r task_name
clear

# Putting it all together
printf -v create "project:%s %s due:%s %s\n" "$project" "$tags" "$duedate" "$task_name"
task add $(echo "$create")
