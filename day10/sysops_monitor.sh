#!/bin/bash

# Initialize necessary variables and configurations
LOG_FILE="$HOME/sysops_monitor.log"
EMAIL="vrajtrivedi567@gmail.com"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
NETWORK_INTERFACE="eth0"
APACHE_SERVICE="apache2"
MYSQL_SERVICE="mysql"

# Validate required commands and utilities
REQUIRED_CMDS=("top" "df" "grep" "awk" "mail" "systemctl" "ifstat")
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is not installed." | tee -a $LOG_FILE
        if [ "$cmd" = "ifstat" ]; then
            echo "Skipping network statistics collection." | tee -a $LOG_FILE
        else
            exit 1
        fi
    fi
done

echo "Script initialized successfully." | tee -a $LOG_FILE

# Function to collect CPU usage
collect_cpu_usage() {
    CPU_USAGE=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    echo "CPU Usage: $CPU_USAGE%" >> $LOG_FILE
}

# Function to collect memory utilization
collect_memory_usage() {
    MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
    echo "Memory Usage: $MEM_USAGE%" >> $LOG_FILE
}

# Function to collect disk space usage
collect_disk_space() {
    df -h | grep '^/dev/' | awk '{ print "Disk Usage: "$5 " on "$1 }' >> $LOG_FILE
}

# Function to collect network statistics
collect_network_stats() {
    if command -v ifstat &> /dev/null; then
        ifstat -i $NETWORK_INTERFACE 1 1 | awk 'NR==3 {print "Network Usage: "$1" In, "$2" Out"}' >> $LOG_FILE
    else
        echo "ifstat is not installed. Skipping network statistics collection." >> $LOG_FILE
    fi
}

# Function to collect top processes
collect_top_processes() {
    echo "Top Processes by CPU Usage:" >> $LOG_FILE
    ps aux --sort=-%cpu | head -n 10 >> $LOG_FILE
}

collect_cpu_usage
collect_memory_usage
collect_disk_space
collect_network_stats
collect_top_processes

echo "System metrics collected successfully." | tee -a $LOG_FILE

# Function to parse system logs
parse_syslogs() {
    echo "Recent Critical Log Entries:" >> $LOG_FILE
    grep -i "error\|critical\|failed" /var/log/syslog | tail -n 50 >> $LOG_FILE
}

parse_syslogs
echo "Log analysis completed successfully." | tee -a $LOG_FILE

# Function to check service status
check_service_status() {
    SERVICES=($APACHE_SERVICE $MYSQL_SERVICE)
    for service in "${SERVICES[@]}"; do
        systemctl is-active --quiet $service
        if [ $? -ne 0 ]; then
            echo "Service $service is not running!" >> $LOG_FILE
        fi
    done
}

check_service_status
echo "Health checks completed successfully." | tee -a $LOG_FILE

# Function to check critical metrics and alert
check_alerts() {
    CPU_USAGE=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')

    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "CPU usage is above threshold: $CPU_USAGE%" | tee -a $LOG_FILE | mail -s "Critical Alert: CPU Usage" $EMAIL
    fi

    if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
        echo "Memory usage is above threshold: $MEM_USAGE%" | tee -a $LOG_FILE | mail -s "Critical Alert: Memory Usage" $EMAIL
    fi

    DISK_USAGE=$(df -h | grep '^/dev/' | awk '{print $5}' | sed 's/%//g')
    for usage in $DISK_USAGE; do
        if [ $usage -gt $DISK_THRESHOLD ]; then
            echo "Disk usage is above threshold: $usage%" | tee -a $LOG_FILE | mail -s "Critical Alert: Disk Usage" $EMAIL
        fi
    done
}

check_alerts
echo "Alerts checked successfully." | tee -a $LOG_FILE

# Function to generate report
generate_report() {
    REPORT_FILE="$HOME/sysops_report_$(date +%F).txt"
    echo "System Monitoring Report - $(date)" > $REPORT_FILE
    cat $LOG_FILE >> $REPORT_FILE
    echo "Report generated at $REPORT_FILE" | tee -a $LOG_FILE
}

generate_report
echo "Report generation completed successfully." | tee -a $LOG_FILE

# Add the script to cron for periodic execution
(crontab -l ; echo "*/5 * * * * /path/to/sysops_monitor.sh") | crontab -

echo "Script scheduled via cron successfully." | tee -a $LOG_FILE

# Function for interactive mode
interactive_mode() {
    echo "Choose an option:"
    echo "1. View System Metrics"
    echo "2. View Logs"
    echo "3. Run Health Checks"
    echo "4. Generate Report"
    read -p "Enter your choice [1-4]: " choice

    case $choice in
        1)
            collect_cpu_usage
            collect_memory_usage
            collect_disk_space
            collect_network_stats
            collect_top_processes
            ;;
        2)
            parse_syslogs
            ;;
        3)
            check_service_status
            ;;
        4)
            generate_report
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
}

# Check if the script is run interactively
if [[ $- == *i* ]]; then
    interactive_mode
else
    collect_cpu_usage
    collect_memory_usage
    collect_disk_space
    collect_network_stats
    collect_top_processes
    parse_syslogs
    check_service_status
    check_alerts
    generate_report
fi

echo "User interaction handled successfully." | tee -a $LOG_FILE
