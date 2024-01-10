#!/bin/sh

updates_pacman=0
re='^[0-9]+$'

if ! updates_pacman=$(checkupdates 2> /dev/null | wc -l ); then
    updates_pacman=0
fi

if ! [[ $updates_pacman =~ $re ]] ; then
   updates_pacman=999; exit 1
fi

echo "  $updates_pacman"
