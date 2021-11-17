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

jql_str = f'assignee = {jira_login} AND resolution = Unresolved AND status not in ' \
          f'(Canceled, Completed, Declined, Tested) ORDER BY Rank ASC'

total = jira_client.search_issues(jql_str)
print(len(total))
