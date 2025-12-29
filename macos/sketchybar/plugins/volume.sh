#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)')
fi

case "$VOLUME" in
  [6-9][0-9]|100) 
    ICON="󰕾"
    COLOR=$WHITE
  ;;
  [3-5][0-9]) 
    ICON="󰖀"
    COLOR=$WHITE
  ;;
  [1-9]|[1-2][0-9]) 
    ICON="󰕿"
    COLOR=$WHITE
  ;;
  *) 
    ICON="󰖁"
    COLOR=$WHITE
esac

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$VOLUME%" label.color="$COLOR"