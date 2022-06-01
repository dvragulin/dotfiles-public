#!/usr/bin/python

import sys,os
from jira.client import JIRA

eget = os.environ.get
jira_url = eget('JIRA_WORK')
jira_login = eget('JIRA_LOGIN_WORK')
token = eget('JIRA_WORK_TOKEN')

try:
    sys.stderr = open(os.devnull, 'wb')
    jira_client = JIRA(options={'server': f'{jira_url}'}, max_retries=0,
                       token_auth=f'{token}')
    project = jira_client.project("INFRADEV")

    filter_1 = f'assignee = {jira_login} AND resolution = Unresolved AND status not in ' \
               f'(Canceled, Completed, Declined, Tested) ORDER BY Rank ASC'
    filter_2 = """
    assignee is EMPTY AND summary ~ "Задача из MM*" AND project = INFRADEV AND status in 
    ("In Progress", Backlog, Blocked, Open, Reopened) AND "Assigned team" = "DevOps-1st-line"  ORDER BY created DESC
    """
    filter_3 = """
    (labels != "DevOps-1st-line" OR labels is EMPTY) AND assignee is EMPTY AND "Assigned team" = DevOps-1st-line 
    AND summary !~"Задача из MM*" AND summary !~ "Запрос доступов*" AND status = "Backlog"  AND project = InfraDev 
    """
    filter_4 = """
    assignee is EMPTY AND summary ~ "Запрос доступов*" AND project = INFRADEV AND status in
    ("In Progress", Backlog, Blocked, Open, Reopened) AND "Assigned team" = "DevOps-1st-line"  ORDER BY created DESC
    """

    print(f" {len(jira_client.search_issues(filter_4))}"
          f" {len(jira_client.search_issues(filter_3))}"
          f" {len(jira_client.search_issues(filter_2))}"
          f" {len(jira_client.search_issues(filter_1))}")

except Exception as e:
    pass
    # print("")
