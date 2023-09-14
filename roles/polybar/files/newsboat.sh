#!/bin/bash

newsboat -x reload
newsboat -x print-unread | awk '{print $1}'

