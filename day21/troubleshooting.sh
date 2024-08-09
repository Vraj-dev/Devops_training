#!/bin/bash

# Variables
LOG_FILE="/var/log/system_log_check.log"
SYSTEM_LOG="/var/log/syslog"
ERROR_KEYWORDS=("Out of memory" "Failed to start" "Segmentation fault" "error" "panic")
TROUBLESHOOT_GUIDE="/var/log/troubleshoot_guide.txt"

# Function to log messages
log_message() {
    local LOG_TYPE=$1
    local MESSAGE=$2
    echo "$(date +"%Y-%m-%d %H:%M:%S") [$LOG_TYPE] : $MESSAGE" | tee -a $LOG_FILE
}

# Function to check logs for common errors
check_logs() {
    log_message "INFO" "Checking system logs for common issues..."

    > $TROUBLESHOOT_GUIDE # Clear previous guide
    for keyword in "${ERROR_KEYWORDS[@]}"; do
        log_message "INFO" "Searching for keyword: $keyword"
        grep -i "$keyword" $SYSTEM_LOG >> $TROUBLESHOOT_GUIDE

        if grep -qi "$keyword" $SYSTEM_LOG; then
            case $keyword in
                "Out of memory")
                    log_message "ERROR" "Out of memory issue found."
                    echo "Troubleshooting Step: Consider increasing swap space or checking for memory leaks in running applications." >> $TROUBLESHOOT_GUIDE
                    ;;
                "Failed to start")
                    log_message "ERROR" "Service failed to start."
                    echo "Troubleshooting Step: Check the service status with 'systemctl status <service-name>' and logs under /var/log." >> $TROUBLESHOOT_GUIDE
                    ;;
                "Segmentation fault")
                    log_message "ERROR" "Segmentation fault detected."
                    echo "Troubleshooting Step: Check for faulty applications or hardware issues. Core dumps may provide more insights." >> $TROUBLESHOOT_GUIDE
                    ;;
                "error")
                    log_message "ERROR" "Generic error detected."
                    echo "Troubleshooting Step: Review the specific error message in the logs for more details." >> $TROUBLESHOOT_GUIDE
                    ;;
                "panic")
                    log_message "ERROR" "System panic detected."
                    echo "Troubleshooting Step: Investigate kernel logs (/var/log/kern.log) for the root cause of the panic." >> $TROUBLESHOOT_GUIDE
                    ;;
            esac
        else
            log_message "INFO" "No issues found for keyword: $keyword"
        fi
    done
}

# Main script execution
log_message "INFO" "Starting log checking and troubleshooting script..."
check_logs
log_message "INFO" "Log checking completed. Troubleshooting guide created at $TROUBLESHOOT_GUIDE."
