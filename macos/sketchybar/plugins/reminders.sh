#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Count incomplete reminders due today or overdue
# Optimized: Fetches only due dates in bulk to avoid slow object iteration
REMINDER_COUNT=$(osascript -e '
tell application "Reminders"
	set endOfToday to current date
	set time of endOfToday to 86399 # 23:59:59
	
	set totalCount to 0
	
	repeat with aList in lists
		# Get list of due dates for all incomplete reminders in this list
		set dueDates to due date of (reminders of aList whose completed is false)
		
		repeat with d in dueDates
			if d is not missing value then
				if d < endOfToday then
					set totalCount to totalCount + 1
				end if
			end if
		end repeat
	end repeat
	
	return totalCount
end tell' 2>/dev/null)

if [ -z "$REMINDER_COUNT" ]; then
  REMINDER_COUNT=0
fi

if [ "$REMINDER_COUNT" -gt 0 ]; then
  sketchybar --set $NAME drawing=on label="$REMINDER_COUNT" icon= icon.color="$ORANGE"
else
  sketchybar --set $NAME drawing=off
fi
