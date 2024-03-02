#!/bin/bash

# Завершить текущие экземпляры polybar
killall -q polybar
killall -q dunst
# Ожидание полного завершения работы процессов
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Запуск Polybar со стандартным расположением конфигурационного файла в ~/.config/polybar/config
polybar dvragulin &
dunst -config ~/.config/dunst/dunstrc &

# Конфигурируем запуск на мониторах и отдельно
connected_screens=$(xrandr | grep -E 'DP-3-2')
if [[ $connected_screens ]]; then
  xrandr --output eDP-1 --off
  xrandr --output DP-3-2 --mode 2560x1440 --pos 0x0 --primary
  xrandr --output DP-3-3 --mode 2560x1440 --pos 2560x0
  notify-send -a "xrandr" -u normal "set configuration:
  eDP-1 is off
  DP-3-2 set primary
  DP-3-3
  "
else
  xrandr --output eDP-1 --primary
  notify-send -a "xrandr" -u normal "set configuration:
  eDP-1 set primary
  DP-3-2 is off
  DP-3-3 is off
  "
fi

notify-send -a "Polybar" -u normal "Welcome!"
yandex-disk start

