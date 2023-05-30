#!/bin/python

import os
import time
import json
import argparse
import requests

eget = os.environ.get

token = eget("IOT_Y_TOKEN")
client_id = eget("IOT_Y_CLIENT_ID")
client_secret = eget("IOT_Y_CLIENT_SECRET")
headers = {'Authorization': f'Bearer {token}'}
device_id = "fbba12b6-6309-42ea-9ac2-2e2c3dbefce1"
icon = " "


def device_action_off():
    data_json = json.loads('"devices": "id": "' + device_id + '","actions": [{"type": '
                                                                 '"devices.capabilities.on_off","state": {"instance": "on","value": false}}]')

    requests.post("https://api.iot.yandex.net/v1.0/devices/actions", headers=headers, json=data_json)
    exit(0)


def device_action_on():
    data_json = json.loads('{"devices": [{"id": "' + device_id + '","actions": [{"type": '
                                                                 '"devices.capabilities.on_off","state": {"instance": "on","value": true}}]}]}')

    requests.post("https://api.iot.yandex.net/v1.0/devices/actions", headers=headers, json=data_json)


def get_status():
    response = requests.get(f"https://api.iot.yandex.net/v1.0/devices/{device_id}", headers=headers)
    json_object = json.loads(response.content.decode('utf-8'))
    if json_object['state'] == 'offline':
        print(f"{icon}: ")
        os.system('notify-send --app-name="Kittle" -u normal "Чайник отключен от сети"')
        exit(0)
    return json_object


def args_pars():
    parser = argparse.ArgumentParser()
    parser.add_argument("--command", help="Use action like ON/OFF", default=None)
    return parser.parse_args()


def kettle_action(action):
    device_info = get_status()
    device_working = device_info['capabilities'][1]['state']['value']
    if device_working is False and action == 1:
        os.system('notify-send --app-name="Kittle" -u normal "Чайник включен"')
        device_action_on()
    if device_working is True and action == 0:
        os.system('notify-send --app-name="Kittle" -u normal "Чайник выключен"')
        device_action_off()


def main(args):
    if args.command == "ON":
        kettle_action(action=1)

        stop_time = time.monotonic() + 300
        while time.monotonic() < stop_time:
            temperature = get_status()["properties"][0]['state']['value']
            if 90 < temperature <= 100:
                os.system('notify-send --app-name="Kittle" -u normal "Чайник вскипел до 90°"')
                break
            time.sleep(10)

    if args.command == "OFF":
        kettle_action(action=0)
    print(icon)


if __name__ == '__main__':
    args = args_pars()
    main(args)

