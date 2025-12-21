#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# Calculate CPU Load
CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_LOAD=$(ps -Aceo %cpu | awk '{s+=$1} END {print s}')
CPU_PERCENT=$(echo "scale=0; $CPU_LOAD / $CORE_COUNT" | bc)

# Dynamic Color
COLOR=$WHITE
if [ "$CPU_PERCENT" -gt 60 ]; then COLOR=$YELLOW; fi
if [ "$CPU_PERCENT" -gt 85 ]; then COLOR=$RED; fi

sketchybar --set $NAME label="$CPU_PERCENT%" icon=CPU icon.color=$COLOR
