#!/bin/bash
DIRECTORY=${2:-/}
THRESHOLD=$1

DISK_USAGE=$(df -h "$DIRECTORY" | awk 'NR > 1 { gsub("%","",$5); print $5 }')
EXIT_CODE=0

if [[ "$THRESHOLD" =~ ^[0-9]+$ ]] && [ "$THRESHOLD" -gt 0 ]&& [ "$THRESHOLD" -le 100 ];
then
    echo "Threshold value: $THRESHOLD"
 else
    echo "Please provide a valid threshold greater than 0."
    EXIT_CODE=2
    exit "$EXIT_CODE"  
fi




if [ "$DISK_USAGE" -ge "$THRESHOLD" ]; then
    echo "Disk usage has reached or exceeded threshold: $DISK_USAGE% (Threshold: $THRESHOLD%)"
    EXIT_CODE=1
else
    echo "Disk usage is below threshold: $DISK_USAGE% (Threshold: $THRESHOLD%)"
fi

exit "$EXIT_CODE"