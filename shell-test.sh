#!/bin/bash
set -xv
printf '%s\n' "$(ps | awk 'FNR==2 {print $4}')"
