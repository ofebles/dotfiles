#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Calculate Memory Pressure (Used %)
PRESSURE=$(memory_pressure -Q | grep "System-wide memory free percentage:" | awk '{ print 100-$5 }')

# Dynamic Color
COLOR=$WHITE
if [ "$PRESSURE" -gt 60 ]; then COLOR=$YELLOW; fi
if [ "$PRESSURE" -gt 85 ]; then COLOR=$RED; fi

sketchybar --set $NAME label="$PRESSURE%" icon= icon.color=$COLOR
