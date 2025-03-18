#!/bin/bash
file="monitor_usb_ports.sh"

# Function to check and modify permissions for USB ports
monitor_usb_ports() {
    echo "Monitoring for USB devices (ttyUSB*)..."
    while true; do
        # Find connected USB devices
        USB_DEVICES=$(ls /dev/ttyUSB* 2>/dev/null)

        if [ -n "$USB_DEVICES" ]; then
            for device in $USB_DEVICES; do
                # Modify permissions to ensure accessibility
                echo "Found USB device: $device"
                echo "Updating permissions for $device..."
                sudo chmod a+rw $device
            done
        else
            echo "No USB devices detected."
        fi

        # Check every 5 seconds
        sleep 5
    done
}

# Run the function
monitor_usb_ports
