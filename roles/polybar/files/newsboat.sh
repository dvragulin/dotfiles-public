#!/bin/bash

newsboat -x reload 1> /dev/null
if [ $? != 0 ]; then
    echo "  "
    exit 0
else
    newsboat -x print-unread | awk '{print $1}'
fi

