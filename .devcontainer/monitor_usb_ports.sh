#!/bin/bash
file="monitor_usb_ports.sh"

echo "Starting USB port monitoring..."

# Function to show connected USB devices
show_usb_devices() {
    echo "USB devices connected:"
    lsusb
    
    echo "Serial ports available:"
    ls -l /dev/tty* | grep -E 'ttyUSB|ttyACM'
    
    echo "Device permissions:"
    stat -c "%a %n" /dev/ttyUSB* /dev/ttyACM* 2>/dev/null || echo "No Arduino devices found"
}

# Initial check
show_usb_devices

# Watch for USB changes every 5 seconds
while true; do
    sleep 5
    
    # Check if any Arduino boards have been connected or disconnected
    CURRENT_DEVICES=$(ls -l /dev/tty* | grep -E 'ttyUSB|ttyACM')
    
    if [ "$CURRENT_DEVICES" != "$PREVIOUS_DEVICES" ]; then
        echo "USB device change detected at $(date)"
        show_usb_devices
        PREVIOUS_DEVICES=$CURRENT_DEVICES
        
        # Ensure correct permissions for any new devices
        for device in /dev/ttyUSB* /dev/ttyACM*; do
            if [ -e "$device" ]; then
                sudo chmod 666 "$device"
                echo "Set permissions for $device"
            fi
        done
    fi
done
