#!/bin/sh

# Network Status Script
# Prioritizes Ethernet over Wi-Fi

# Check Ethernet (en0) status
# Returns "active" if connected
ETHERNET_STATUS=$(ifconfig en0 | grep "status: active")

if [ -n "$ETHERNET_STATUS" ]; then
  # Ethernet is active
  sketchybar --set $NAME label="" label.drawing=off icon=󰈀 icon.padding_right=2
else
  # Check Wi-Fi (en1)
  SSID=$(networksetup -getairportnetwork en1 | cut -d: -f2 | xargs)
  
  if [ "$SSID" = "You are not associated with an AirPort network." ] || [ "$SSID" = "Wi-Fi power is off" ] || [ -z "$SSID" ]; then
    # Fallback: Check if we have an IP address on the interface
    IP=$(ifconfig en1 | grep "inet " | awk '{print $2}')
    if [ -n "$IP" ]; then
       sketchybar --set $NAME label="" label.drawing=off icon=󰤨 icon.padding_right=2
    else
       sketchybar --set $NAME label="Disconnected" label.drawing=on icon=󰤮 icon.padding_right=10
    fi
  else
     sketchybar --set $NAME label="" label.drawing=off icon=󰤨 icon.padding_right=2
  fi
fi
