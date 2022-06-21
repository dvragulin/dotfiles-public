#!/usr/bin/python
# -*- coding: utf-8 -*-
# req. pip install todoist-api-python

import os
from todoist_api_python.api import TodoistAPI


def beauty(inbox, priority, today):
    return f" {today}  {priority}  {inbox}"


def main(token):
    api = TodoistAPI(token)
    inbox_count, priority_count, today_count = 0, 0, 0

    try:
        tasks = api.get_tasks()
        for task in tasks:
            if task.project_id == 2161168161:
                inbox_count += 1
            if task.priority == 1:
                priority_count += 1
            try:
                if task.due.string == "today":
                    today_count += 1
            except Exception:
                pass
    except Exception as error:
        print(error)

    print(beauty(inbox_count, priority_count, today_count))


if __name__ == '__main__':
    eget = os.environ.get
    token = eget('TODOIST_TOKEN')
    main(token)
