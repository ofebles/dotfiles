#!/bin/bash

source "$CONFIG_DIR/colors.sh"

get_dock_badge() {
  app_name="$1"
  osascript -e "
    tell application \"System Events\"
      tell process \"Dock\"
        try
          return value of attribute \"AXStatusLabel\" of UI element \"$app_name\" of list 1
        on error
          return \"0\"
        end try
      end tell
    end tell" 2>/dev/null
}

# OUTLOOK
# Try getting count from Dock badge (works for New and Old Outlook)
OUTLOOK_COUNT=$(get_dock_badge "Microsoft Outlook")

# TEAMS
# Check for both common names
TEAMS_COUNT=$(get_dock_badge "Microsoft Teams")
if [ "$TEAMS_COUNT" = "0" ] || [ -z "$TEAMS_COUNT" ]; then
  TEAMS_COUNT=$(get_dock_badge "Microsoft Teams (work or school)")
fi

# Clean up outputs (sometimes returns "missing value" or text)
if [ "$OUTLOOK_COUNT" = "missing value" ]; then OUTLOOK_COUNT="0"; fi
if [ "$TEAMS_COUNT" = "missing value" ]; then TEAMS_COUNT="0"; fi

# Ensure they are numbers
[[ $OUTLOOK_COUNT =~ ^[0-9]+$ ]] || OUTLOOK_COUNT=0
[[ $TEAMS_COUNT =~ ^[0-9]+$ ]] || TEAMS_COUNT=0

# Update Outlook item
if [ "$OUTLOOK_COUNT" -gt 0 ]; then
  sketchybar --set outlook_info drawing=on label="$OUTLOOK_COUNT" icon.color="$WHITE"
else
  sketchybar --set outlook_info drawing=off
fi

# Update Teams item
if [ "$TEAMS_COUNT" -gt 0 ]; then
  sketchybar --set teams_info drawing=on label="$TEAMS_COUNT" icon.color="$WHITE"
else
  sketchybar --set teams_info drawing=off
fi
