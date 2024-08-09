#!/bin/bash

# Configuration
LOG_DIR="/var/log/myapp"    # Directory containing logs
ARCHIVE_DIR="/var/log/myapp/archive"  # Directory to store compressed logs
LOG_SIZE_THRESHOLD=10485760  # 10MB in bytes
LOG_RETENTION_DAYS=30        # Retain logs for 30 days
REPORT_FILE="/var/log/myapp/log_management_report.txt"

# Ensure the archive directory exists
mkdir -p "$ARCHIVE_DIR"

# Start the report
echo "Log Management Report - $(date)" > "$REPORT_FILE"
echo "=====================================" >> "$REPORT_FILE"

# Rotate, compress, and delete logs
for log_file in "$LOG_DIR"/*.log; do
    if [[ -f "$log_file" ]]; then
        log_size=$(stat -c%s "$log_file")
        log_filename=$(basename "$log_file")
        
        # Rotate and compress if the log file size exceeds the threshold
        if [[ $log_size -ge $LOG_SIZE_THRESHOLD ]]; then
            gzip "$log_file"
            mv "${log_file}.gz" "$ARCHIVE_DIR"
            echo "Rotated and compressed: $log_filename (size: $log_size bytes)" >> "$REPORT_FILE"
        fi
        
        # Delete logs older than specified retention days
        find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +$LOG_RETENTION_DAYS -exec rm {} \;
        if [[ $? -eq 0 ]]; then
            echo "Deleted logs older than $LOG_RETENTION_DAYS days" >> "$REPORT_FILE"
        fi
    fi
done

# Finish the report
echo "Log management tasks completed successfully." >> "$REPORT_FILE"
