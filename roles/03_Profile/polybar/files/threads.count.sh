#!/bin/bash

COUNT=$(
  curl -sS \
  -X GET \
  -H "Content-type: application/json; charset=utf-8" \
  -H "Authorization: Bearer $MATTERMOST_TOKEN" \
  "$MATTERMOST_HOST/api/v4/users/$MATTERMOST_USER_ID/teams/$MATTERMOST_TEAM_ID/threads" | jq ".total"
)

if [ $COUNT -gt 50 ]; then echo "%{F#cebaba}  $COUNT"; else echo   $COUNT; fi

