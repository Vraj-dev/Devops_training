#!/bin/bash

# Script to check memory usage

LOGFILE="/var/log/memory_usage.log"

# Check memory usage and log output
check_memory_usage() {
  free -h > $LOGFILE 2>&1
  if [ $? -eq 0 ]; then
    echo "Memory usage checked successfully. Output logged to $LOGFILE."
  else
    echo "Error checking memory usage. Check the log at $LOGFILE for more details." >&2
  fi
}

check_memory_usage

