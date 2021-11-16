#!/usr/bin/bash
todo s

#ALL_TASKS=$(todo l | awk ' {print $1} ' | wc -l)
TODAY_TASKS=$(todo l | awk ' {print $3} ' | rg / | wc -l)

P1_TASKS=$(todo l | rg "p1" | awk ' {print $1} ' | wc -l)

echo -ne "$TODAY_TASKS  $P1_TASKS" 

