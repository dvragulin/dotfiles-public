#!/bin/bash

VAR=$(amixer | rg "Mono: Capture" | rg "\[on\]" | awk '{print $5}')
if  [[ $VAR = "[on]" ]]; then echo %{F\#7AB87A}; else echo ""; fi

#amixer set Capture toggle
