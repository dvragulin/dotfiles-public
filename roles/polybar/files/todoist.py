#!/usr/bin/python
# -*- coding: utf-8 -*-
# req. pip install todoist-api-python

import os
from datetime import datetime
from todoist_api_python.api import TodoistAPI

def beauty(inbox, priority, today):
    return f" {inbox}  {today}  {priority}"


def get_due_date(task):
    if task.due is not None:
        due_date = str(datetime.fromisoformat(task.due.date)).split(" ")[0]
    else:
        due_date = None
    return due_date


def main(token):
    api = TodoistAPI(token)
    inbox_count, today_priority_count, today_count = 0, 0, 0
    today = datetime.today().strftime('%Y.%m.%d').replace(".", "-")
    tasks = api.get_tasks()

    for task in tasks:
        due_date = get_due_date(task)
        if task.project_id == 2161168161:
            inbox_count += 1
        if due_date == today:
            today_count += 1
        if task.priority == 4:
            if due_date == today:
                today_priority_count += 1

    print(beauty(inbox_count, today_priority_count, today_count))


if __name__ == '__main__':
    eget = os.environ.get
    token = eget('TODOIST_TOKEN')
    main(token)
