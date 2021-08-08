#!/bin/bash

# Завершить текущие экземпляры polybar
killall -q polybar
killall -q dunst
# Ожидание полного завершения работы процессов
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Запуск Polybar со стандартным расположением конфигурационного файла в ~/.config/polybar/config
polybar dvragulin &
dunst -config ~/.config/dunst/dunstrc &

notify-send -a "Polybar" -u normal "Polybar running..."

