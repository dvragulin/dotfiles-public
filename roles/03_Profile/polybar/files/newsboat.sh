#!/bin/bash

if ! newsboat -x reload 1> /dev/null; then
    echo "  "
    exit 0
else
    newsboat -x print-unread | awk '{print $1}'
fi
