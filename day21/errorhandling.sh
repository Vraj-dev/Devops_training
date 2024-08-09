#!/bin/bash

# Set variables
LOG_FILE="/var/log/system_monitor.log"
DISK_THRESHOLD=80
MEMORY_THRESHOLD=90

# Function to log messages
log_message() {
    local LOG_TYPE=$1
    local MESSAGE=$2
    echo "$(date +"%Y-%m-%d %H:%M:%S") [$LOG_TYPE] : $MESSAGE" | tee -a $LOG_FILE
}

# Function to check disk usage
check_disk_usage() {
    log_message "INFO" "Checking disk usage..."
    for partition in $(df -h | grep '^/dev/' | awk '{print $1}'); do
        usage=$(df -h | grep $partition | awk '{print $5}' | sed 's/%//')
        if [ $usage -ge $DISK_THRESHOLD ]; then
            log_message "ERROR" "Disk usage for $partition is above threshold: ${usage}%"
        else
            log_message "INFO" "Disk usage for $partition is under control: ${usage}%"
        fi
    done
}

# Function to check memory usage
check_memory_usage() {
    log_message "INFO" "Checking memory usage..."
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    memory_usage=${memory_usage%.*}
    if [ $memory_usage -ge $MEMORY_THRESHOLD ]; then
        log_message "ERROR" "Memory usage is above threshold: ${memory_usage}%"
    else
        log_message "INFO" "Memory usage is under control: ${memory_usage}%"
    fi
}

# Error handling for missing files or insufficient permissions
error_handling() {
    local ERROR_MSG=$1
    log_message "ERROR" "$ERROR_MSG"
    exit 1
}

# Ensure the log file is writable
if [ ! -w "$LOG_FILE" ]; then
    error_handling "Log file $LOG_FILE is not writable or does not exist."
fi

# Main script execution
log_message "INFO" "Starting system monitoring script..."

check_disk_usage
check_memory_usage

log_message "INFO" "System monitoring script completed successfully."
