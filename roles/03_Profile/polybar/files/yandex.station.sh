#!/bin/bash
DEVICE_YC="bluez_sink.B8_87_6E_AC_9A_5C.a2dp_sink"
DEVICE_HS="alsa_output.usb-Conexant_Sennheiser_Main_Audio_00000000-00.analog-stereo"
STATION="B8:87:6E:AC:9A:5C"

device_is_found() {
    bluetoothctl devices | grep -q "$STATION"
}

choose_sink() {
  input_str="$1"

  if [[ "$input_str" == "haedphones" ]]; then
    DEVICE="alsa_output.usb-Conexant_Sennheiser_Main_Audio_00000000-00.analog-stereo"
    notify-send -a "Sennheiser" -u normal "Switching"
    pacmd set-default-sink $DEVICE
    pactl set-sink-volume $DEVICE 100%
    pactl list sink-inputs short | while read stream; do
      stream_id=$(echo $stream | cut -f1)
      pactl move-sink-input "$stream_id" "$DEVICE"
    done
    bluetoothctl disconnect $STATION 2>&1 1>/dev/null
    bluetoothctl remove $STATION 2>&1 1>/dev/null
    notify-send -a "Яндекс.Станция" -u normal "Disconected..."
  elif [[ "$input_str" == "yandex.station" ]]; then
    DEVICE=$DEVICE_YC
    notify-send -a "Яндекс.Станция" -u normal "Switching..."
    { 
    echo "power on"
        sleep 1
        echo "scan on"
        sleep 5
        echo "devices"
        sleep 1
        echo "scan off"
        sleep 1
        echo "pair $STATION"
        sleep 5
        echo "connect $STATION"
    } | bluetoothctl
    #bluetoothctl connect $STATION 2>&1 1>/dev/null && sleep 5
    notify-send -a "Яндекс.Станция" -u normal "Connected..."
    sleep 5
    pacmd set-default-sink $DEVICE
    pactl list sink-inputs short | while read stream; do
      stream_id=$(echo $stream | cut -f1)
      pactl move-sink-input "$stream_id" "$DEVICE"
    done
    pactl set-sink-volume $DEVICE 30%
    notify-send -a "Яндекс.Станция" -u normal "Switched..."
    else
    return 0
  fi
}

choose_sink "$1"
VAR=$(pactl list short | rg $DEVICE_YC | head -1 | awk '{print $1}')
if  [[ -z $VAR ]]; then echo 󰋋 ; else echo %{F\#7AB87A} ; fi
