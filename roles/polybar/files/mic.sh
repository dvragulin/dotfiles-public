#!/bin/bash

VAR=$(amixer | rg "Mono: Capture" | rg "\[on\]" | awk '{print $5}')
if  [[ $VAR = "[on]" ]]; then echo ""; else echo %{F\#FF0000} %{F-}; fi

#amixer set Capture toggle