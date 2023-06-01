#!/usr/bin/python

import sys, os
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
                  f'(Canceled, Completed, Declined, Tested) AND project=InfraDev ORDER BY Rank ASC'

    jira_filter_backlog = f'assignee in (EMPTY) AND Labels = from_ITSD AND project = INFRADEV ' \
                          f'AND status in ("In Progress", Backlog, Blocked, Open, Reopened) AND "Assigned team" = ' \
                          f'DevOps-1st-line ORDER BY created DESC'

    jira_filter_RFC = f'project = rfc AND status in ("PaaS Done")'
    jira_filter_RFC_INF = f'project = rfc AND status in ("Release In Progress")'

    # TODO: Change `RFC_TASK_D` to `RFC_TASK`
    RFC_TASK_D = list({len(jira_client.search_issues(jira_filter_RFC))})
    # TODO: Delete
    RFC_TASK_P = list({len(jira_client.search_issues(jira_filter_RFC_INF))})

    jira_report = f"  {len(jira_client.search_issues(jira_filter))}" \
                  f"{len(jira_client.search_issues(jira_filter_backlog))}"

    if RFC_TASK_D[0] > 0:
        jira_report = jira_report + f" 󰙊  {RFC_TASK_D[0]}"

    # TODO: Delete
    if RFC_TASK_D[0] > 0 or RFC_TASK_P[0] > 0:
        jira_report = jira_report + f" 󰢷  {RFC_TASK_P[0]}"

    print(jira_report)

except Exception as e:
    print("")
