#!/bin/sh

#DIR=$(df -h /home | grep dev | awk -F ' ' '{ print $4 }' | sed 's/\G//')
DIR=$(df -h /home | grep dev | awk -F ' ' '{ print $4 }')
VOL=$(df -h /home | grep dev | awk -F ' ' '{ print $2 }')
PER=$(df -h /home | grep dev | awk -F ' ' '{ print $5 }')

if [[ "${DIR}" ]]; then
  echo "${DIR} / ${VOL} (${PER}) "
fi
