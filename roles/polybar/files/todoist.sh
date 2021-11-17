#!/usr/bin/bash
todo s

TODAY_TASKS=$(todo l | awk ' {print $3} ' | rg / | wc -l)

P1_TASKS=$(todo l | rg "p1" | awk ' {print $1} ' | wc -l)
IN_TASKS=$(todo l | rg "Inbox" | awk ' {print $1} ' | wc -l)

echo -ne "$TODAY_TASKS  $P1_TASKS  $IN_TASKS"
