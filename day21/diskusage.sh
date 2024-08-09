#!/bin/bash

# Script to check disk usage

LOGFILE="/var/log/disk_usage.log"

# Check disk usage and log output
check_disk_usage() {
  df -h | grep '^/dev/' > $LOGFILE 2>&1
  if [ $? -eq 0 ]; then
    echo "Disk usage checked successfully. Output logged to $LOGFILE."
  else
    echo "Error checking disk usage. Check the log at $LOGFILE for more details." >&2
  fi
}

check_disk_usage
