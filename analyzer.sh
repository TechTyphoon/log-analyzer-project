#!/bin/bash

# The log file we want to analyze
LOG_FILE="/var/log/syslog"

echo "Analyzing log file: $LOG_FILE"

# Use 'grep' to find and '-c' to count the lines with "error"
error_count=$(grep -c "error" $LOG_FILE)

# Count the lines with "warning"
warning_count=$(grep -c "warning" $LOG_FILE)

echo "Number of 'error' lines: $error_count"
echo "Number of 'warning' lines: $warning_count"
