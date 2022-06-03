#!/bin/bash
if [ `cat /etc/mtab | grep NAS | wc -l` -eq 0 ]; then echo "轢"; else echo "歷"; fi
