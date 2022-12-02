#!/bin/sh
updates_arch=0
updates_aur=0
re='^[0-9]+$'

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(yay -Qum | wc -l); then
    updates_aur=0
fi

if ! [[ $updates_arch =~ $re ]] ; then
   updates_aur=999; exit 1
fi

if ! [[ $updates_arch =~ $re ]] ; then
   updates_aur=999; exit 1
fi

echo " $updates_arch  $updates_aur"
