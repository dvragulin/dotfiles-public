#!/usr/bin/python

import os
from jira.client import JIRA

eget = os.environ.get
jira_url = eget('JIRA_WORK')
jira_login = eget('JIRA_LOGIN_WORK')
email = eget('EMAIL_WORK')
token = eget('JIRA_WORK_TOKEN')

jira_client = JIRA(options={'server': f'{jira_url}'},
                   basic_auth=(f'{email}', f'{token}'))
project = jira_client.project("INFRADEV")

filter_1 = f'assignee = {jira_login} AND resolution = Unresolved AND status not in ' \
           f'(Canceled, Completed, Declined, Tested) ORDER BY Rank ASC'
filter_2 = """
assignee in (EMPTY) AND summary ~ "Задача из Slack*" AND project = INFRADEV AND status in ("In Progress", Backlog, Blocked, Open, Reopened) AND "Assigned team[Dropdown]" = DevOps-1st-line ORDER BY created DESC
"""

print(f"{len(jira_client.search_issues(filter_1))} {len(jira_client.search_issues(filter_2))}")
