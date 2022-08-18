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
xrandr --output eDP-1 --off
notify-send -a "xrandr" -u normal "Xrandr updated..."
yandex-disk start
notify-send -a "Yandex.Disk" -u normal "Yandex Disk running..."
