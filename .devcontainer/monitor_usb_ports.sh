#!/bin/bash

# Ensure the initial state file exists
if [ ! -f /tmp/usb_state ]; then
    touch /tmp/usb_state
fi

# Log file for debugging
LOG_FILE="/tmp/monitor_usb_ports.log"
echo "Starting USB monitor script at $(date)" > "$LOG_FILE"

# Monitor USB ports and log changes
while true; do
    lsusb > /tmp/usb_state_new 2>>"$LOG_FILE"
    if ! cmp -s /tmp/usb_state /tmp/usb_state_new; then
        echo "USB devices changed at $(date):" >> "$LOG_FILE"
        diff /tmp/usb_state /tmp/usb_state_new >> "$LOG_FILE" 2>&1 || true
        mv /tmp/usb_state_new /tmp/usb_state
    fi
    sleep 2
done
