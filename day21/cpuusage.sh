#!/bin/bash

# Script to check CPU load

LOGFILE="/var/log/cpu_load.log"

# Check CPU load and log output
check_cpu_load() {
  uptime > $LOGFILE 2>&1
  if [ $? -eq 0 ]; then
    echo "CPU load checked successfully. Output logged to $LOGFILE."
  else
    echo "Error checking CPU load. Check the log at $LOGFILE for more details." >&2
  fi
}

check_cpu_load
