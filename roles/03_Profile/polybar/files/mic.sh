#!/bin/bash

VAR=$(amixer -c 1 2>/dev/null | rg "Mono: Capture" | rg "\[on\]" | awk '{print $6}')
if  [[ $VAR = "[on]" ]]; then echo ; else echo %{F\#cebaba}; fi
