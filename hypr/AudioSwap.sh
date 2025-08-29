#!/bin/bash

# Define the two sinks you want to toggle between
SINK_1="alsa_output.usb-Universal_Audio_Volt_2_24412037108132-00.HiFi__Line1__sink"
SINK_2="alsa_output.pci-0000_74_00.6.analog-stereo"

# Get current default sink
CURRENT_SINK=$(pactl info | grep 'Default Sink' | awk '{print $3}')

# Decide which sink to switch to
if [ "$CURRENT_SINK" = "$SINK_1" ]; then
    NEW_SINK="$SINK_2"
else
    NEW_SINK="$SINK_1"
fi

# Set the new default sink silently
pactl set-default-sink "$NEW_SINK" >/dev/null 2>&1

# Move all sink inputs to the new sink silently
for INPUT in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$INPUT" "$NEW_SINK" >/dev/null 2>&1
done
