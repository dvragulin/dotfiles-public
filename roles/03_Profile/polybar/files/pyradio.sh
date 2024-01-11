#!/bin/bash
killall -q mpv

PLAYLIST_PATH="$HOME/.config/pyradio/stations.csv"

STATION_LINE=$(grep Music ${PLAYLIST_PATH} | shuf -n 1)
STATION_NAME=$(echo "${STATION_LINE}" | awk -v FS=", " '{ print $1}')
STATION_URL=$(echo "${STATION_LINE}" | awk -v FS=", " '{ print $2}')

notify-send -a "PyRadio" -u normal "${STATION_NAME}"
mpv ${STATION_URL} --volume=50
