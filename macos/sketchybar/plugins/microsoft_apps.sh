#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# OUTLOOK
OUTLOOK_COUNT=$(osascript -e '
if application "Microsoft Outlook" is running then
	tell application "Microsoft Outlook"
		set unreadCount to 0
		repeat with theAccount in every main account
			set unreadCount to unreadCount + (unread count of inbox of theAccount)
		end repeat
		return unreadCount
	end tell
else
	return 0
end if' 2>/dev/null)

# TEAMS
# Try both common process names
TEAMS_COUNT=$(osascript -e '
tell application "System Events"
	set processName to ""
	if exists (process "Microsoft Teams") then
		set processName to "Microsoft Teams"
	else if exists (process "Microsoft Teams (work or school)") then
		set processName to "Microsoft Teams (work or school)"
	end if
	
	if processName is not "" then
		tell process "Dock"
			try
				set badgeValue to value of attribute "AXStatusLabel" of UI element processName of list 1
				if badgeValue is missing value then set badgeValue to "0"
				return badgeValue
			on error
				return "0"
			end try
		end tell
	else
		return "0"
	end if
end tell' 2>/dev/null)

# Reset counts if they are not numbers (sometimes "AXStatusLabel" returns text or empty)
[[ $OUTLOOK_COUNT =~ ^[0-9]+$ ]] || OUTLOOK_COUNT=0
[[ $TEAMS_COUNT =~ ^[0-9]+$ ]] || TEAMS_COUNT=0

# Update Outlook item
if [ "$OUTLOOK_COUNT" -gt 0 ]; then
  sketchybar --set outlook_info drawing=on label="$OUTLOOK_COUNT" icon.color="$BLUE"
else
  sketchybar --set outlook_info drawing=off
fi

# Update Teams item
if [ "$TEAMS_COUNT" != "0" ] && [ -n "$TEAMS_COUNT" ]; then
  sketchybar --set teams_info drawing=on label="$TEAMS_COUNT" icon.color="$MAGENTA"
else
  sketchybar --set teams_info drawing=off
fi
