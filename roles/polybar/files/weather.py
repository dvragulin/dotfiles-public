#!/usr/bin/python

import os

import requests
import json


def request_to_yadnex(token, lat, lon):
    header = {"X-Yandex-API-Key": f"{token}"}
    URL = f"https://api.weather.yandex.ru/v2/forecast/?lat={lat}&lon={lon}"

    response = requests.get(url=URL, headers=header)
    if response.status_code == 403:
        exit('')
    weather = json.loads(response.content.decode('utf-8'))

    return weather


def beauty(weather_data):
    """
    Ссылка на документацию: https://yandex.ru/dev/weather/doc/dg/concepts/about.html
    clear                  / ясно.
    partly-cloudy          / малооблачно.
    cloudy                 / облачно с прояснениями.
    overcast               / пасмурно.
    drizzle                / морось.
    light-rain             / небольшой дождь.
    rain                   / дождь.
    moderate-rain          / умеренно сильный дождь.
    heavy-rain             / сильный дождь.
    continuous-heavy-rain  / длительный сильный дождь.
    showers                / ливень.
    wet-snow               / дождь со снегом.
    light-snow             / небольшой снег.
    snow                   / снег.
    snow-showers           / снегопад.
    hail                   / град.
    thunderstorm           / гроза.
    thunderstorm-with-rain / дождь с грозой.
    thunderstorm-with-hail / гроза с градом.
    """
    conditions = {'clear': '',
                  'partly-cloudy': '',
                  'cloudy': '',
                  'overcast': '',
                  'drizzle': '',
                  'light-rain': '',
                  'rain': '',
                  'moderate-rain': '',
                  'heavy-rain': '',
                  'continuous-heavy-rain': '',
                  'showers': '',
                  'wet-snow': '',
                  'light-snow': '',
                  'snow': '',
                  'snow-showers': '',
                  'hail': '',
                  'thunderstorm': '',
                  'thunderstorm-with-rain': '',
                  'thunderstorm-with-hail': ''}
    icon = None
    temp = weather_data['fact']['temp']
    feels_like = weather_data['fact']['feels_like']
    condition = weather_data['fact']['condition']
    for key, value in conditions.items():
        if key == condition:
            icon = value
    report = f"{temp}°{feels_like}° {icon} "
    return report


def main():
    eget = os.environ.get
    token = eget('YANDEX_API_TOKEN')
    lat = 55.917238
    lon = 37.549502
    weather_data = request_to_yadnex(token, lat, lon)
    print(beauty(weather_data))


if __name__ == '__main__':
    main()
