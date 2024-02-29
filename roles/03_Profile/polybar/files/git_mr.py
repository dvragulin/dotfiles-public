#!/usr/bin/python

import os
import requests
import json

eget = os.environ.get
gitlab = eget('GITLAB_WORK')
token = eget('GITLAB_WORK_TOKEN')
mr_URL = f"{gitlab}/api/v4/merge_requests/?assignee_username=dmitriy.ragulin&state=opened&access_token={token}"

mr_body = "false"

try:
    mr_response = requests.get(url=mr_URL)
    mr_body = json.loads(mr_response.content.decode('utf-8'))
except Exception:
    print("")
    # print("- / - ")

print(f"  {len(mr_body)} ")
