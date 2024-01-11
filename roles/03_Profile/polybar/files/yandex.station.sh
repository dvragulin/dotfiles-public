#!/bin/bash
DEVICE_YC="bluez_sink.B8_87_6E_AC_9A_5C.a2dp_sink"
DEVICE_HS="alsa_output.usb-Conexant_Sennheiser_Main_Audio_00000000-00.analog-stereo"

choose_sink() {
  input_str="$1"

  if [[ "$input_str" == "haedphones" ]]; then
    DEVICE="alsa_output.usb-Conexant_Sennheiser_Main_Audio_00000000-00.analog-stereo"
    notify-send -a "Sennheiser" -u normal "switching"
    pacmd set-default-sink $DEVICE
    pactl set-sink-volume $DEVICE 100%
    pactl list sink-inputs short | while read stream; do
      stream_id=$(echo $stream | cut -f1)
      pactl move-sink-input "$stream_id" "$DEVICE"
    done
    bluetoothctl disconnect B8:87:6E:AC:9A:5C 2>&1 1>/dev/null
  elif [[ "$input_str" == "yandex.station" ]]; then
    DEVICE=$DEVICE_YC
    notify-send -a "Яндекс.Станция" -u normal "switching"
    bluetoothctl connect B8:87:6E:AC:9A:5C 2>&1 1>/dev/null && sleep 5
    pacmd set-default-sink $DEVICE
    pactl list sink-inputs short | while read stream; do
      stream_id=$(echo $stream | cut -f1)
      pactl move-sink-input "$stream_id" "$DEVICE"
    done
    pactl set-sink-volume $DEVICE 30%
    else
    return 0
  fi
}

choose_sink "$1"
VAR=$(pactl list short | rg $DEVICE_YC | head -1 | awk '{print $1}')
if  [[ -z $VAR ]]; then echo 󰋋 ; else echo %{F\#7AB87A}󰂰 ; fi
