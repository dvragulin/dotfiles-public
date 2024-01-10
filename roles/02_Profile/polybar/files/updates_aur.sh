#!/bin/sh
updates_aur=0
re='^[0-9]+$'


if ! updates_aur=$(yay -Qum | wc -l); then
    updates_aur=0
fi

if ! [[ $updates_aur =~ $re ]] ; then
   updates_aur=999; exit 1
fi

echo "  $updates_aur"
