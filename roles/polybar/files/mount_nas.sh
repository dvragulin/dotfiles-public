#!/bin/bash
if [ `cat /etc/mtab | grep NAS | wc -l` -eq 0 ]; then echo " "; else echo %{F\#7AB87A} %{F-}; fi

