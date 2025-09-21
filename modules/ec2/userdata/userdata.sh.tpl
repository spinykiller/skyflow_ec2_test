#!/bin/bash
# Enhanced script to format, mount EBS volumes, and add to fstab
# Log all operations for debugging
exec > >(tee /var/log/ebs-setup.log) 2>&1

echo "Starting EBS volume setup at $(date)"

# Wait for EBS volumes to be attached
sleep 30

# Function to check if device exists
check_device() {
    local device=$1
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if [ -b "$device" ]; then
            echo "Device $device is available"
            return 0
        fi
        echo "Attempt $attempt: Device $device not found, waiting..."
        sleep 10
        ((attempt++))
    done
    
    echo "ERROR: Device $device not found after $max_attempts attempts"
    return 1
}

# Function to format and mount volume
setup_volume() {
    local device=$1
    local mount_point=$2
    local volume_name=$3
    
    echo "Setting up volume: $volume_name"
    echo "Device: $device"
    echo "Mount point: $mount_point"
    
    # Check if device exists
    if ! check_device "$device"; then
        echo "ERROR: Skipping volume $volume_name - device $device not available"
        return 1
    fi
    
    # Check if already mounted
    if mountpoint -q "$mount_point" 2>/dev/null; then
        echo "WARNING: $mount_point is already mounted"
        return 0
    fi
    
    # Create mount point directory
    if [ ! -d "$mount_point" ]; then
        echo "Creating mount point directory: $mount_point"
        mkdir -p "$mount_point"
    fi
    
    # Check if device has filesystem
    if ! blkid "$device" >/dev/null 2>&1; then
        echo "Formatting device $device with XFS filesystem"
        mkfs -t xfs -f "$device"
        if [ $? -ne 0 ]; then
            echo "ERROR: Failed to format device $device"
            return 1
        fi
    else
        echo "Device $device already has a filesystem"
    fi
    
    # Mount the device
    echo "Mounting $device to $mount_point"
    mount -t xfs "$device" "$mount_point"
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to mount $device to $mount_point"
        return 1
    fi
    
    # Add to fstab if not already present
    if ! grep -q "$device.*$mount_point" /etc/fstab; then
        echo "Adding $device to /etc/fstab"
        echo "$device $mount_point xfs defaults,nofail 0 2" >> /etc/fstab
    else
        echo "Entry for $device already exists in /etc/fstab"
    fi
    
    echo "Successfully set up volume $volume_name"
    return 0
}

# Process each volume
%{ for vol in volumes ~}
%{ if vol.device_name != "" && vol.mount_point != "" ~}
setup_volume "${vol.device_name}" "${vol.mount_point}" "${vol.name}"
%{ endif ~}
%{ endfor ~}

# Verify all mounts
echo "Verifying all mounts..."
mount -a

# Show final mount status
echo "Final mount status:"
df -h | grep -E "(Filesystem|/dev/)"

echo "EBS volume setup completed at $(date)"
