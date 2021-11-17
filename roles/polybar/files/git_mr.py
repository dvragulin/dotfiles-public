#!/usr/bin/python

import os
import requests
import json

eget = os.environ.get
gitlab = eget('GITLAB_WORK')
token = eget('GITLAB_WORK_TOKEN')
mr_URL = f"{gitlab}/api/v4/merge_requests/?assignee_username=dmitriy.ragulin&state=opened&access_token={token}"
rw_URL = f"{gitlab}/api/v4/merge_requests/?reviewer_username=dmitriy.ragulin&state=opened&access_token={token}"

mr_response = requests.get(url=mr_URL)
rw_response = requests.get(url=rw_URL)
mr_body = json.loads(mr_response.content.decode('utf-8'))
rw_body = json.loads(rw_response.content.decode('utf-8'))

print(f"{len(mr_body)}/{len(rw_body)} ")

