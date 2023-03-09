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

    jira_filter = f'assignee = {jira_login} AND resolution = Unresolved AND status not in ' \
               f'(Canceled, Completed, Declined, Tested) ORDER BY Rank ASC'

    jira_filter_backlog = f'assignee in (EMPTY) AND summary ~ "Запрос доступов*" AND project = INFRADEV ' \
                          f'AND status in ("In Progress", Backlog, Blocked, Open, Reopened) AND "Assigned team" = ' \
                          f'DevOps-1st-line ORDER BY created DESC'

    print(f" ⸽   {len(jira_client.search_issues(jira_filter))}{len(jira_client.search_issues(jira_filter_backlog))}")

except Exception as e:
    pass
    # print("")
