#!/bin/bash

COUNT_THREADS=$(
  curl -sS \
  -X GET \
  -H "Content-type: application/json; charset=utf-8" \
  -H "Authorization: Bearer $MATTERMOST_TOKEN" \
  "$MATTERMOST_HOST/api/v4/users/$MATTERMOST_USER_ID/teams/$MATTERMOST_TEAM_ID/threads" | jq ".total"
)

COUNT_FLAGGED=$(
  curl -sS \
  -X GET \
  -H "Content-type: application/json; charset=utf-8" \
  -H "Authorization: Bearer $MATTERMOST_TOKEN" \
  "$MATTERMOST_HOST/api/v4/users/$MATTERMOST_USER_ID/posts/flagged" | jq -r '.order | length'
)

if [ $COUNT_THREADS -gt 25 ]; then echo "  $COUNT_FLAGGED  %{F#cebaba}  $COUNT_THREADS"; else echo "  $COUNT_FLAGGED    $COUNT_THREADS"; fi

