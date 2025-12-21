#!/bin/sh

# Network Status Script
# Prioritizes Ethernet over Wi-Fi

# Check Ethernet (en0) status
# Returns "active" if connected
ETHERNET_STATUS=$(ifconfig en10 | grep "status: active")

if [ -n "$ETHERNET_STATUS" ]; then
  # Ethernet is active
  sketchybar --set $NAME label="Ethernet" icon=󰈀
else
  # Check Wi-Fi (en1)
  SSID=$(networksetup -getairportnetwork en0 | cut -d: -f2 | xargs)
  
  if [ "$SSID" = "You are not associated with an AirPort network." ] || [ "$SSID" = "Wi-Fi power is off" ] || [ -z "$SSID" ]; then
     sketchybar --set $NAME label="Disconnected" icon=󰤮
  else
     sketchybar --set $NAME label="$SSID" icon=󰤨
  fi
fi
