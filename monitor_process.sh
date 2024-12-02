#!/bin/bash
# Тестовое задание для Effective Mobile. Выполнил Вырупаев Матвей Антонович
PROCESS_NAME="test"
MONITORING_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"

PID=$(pgrep "$PROCESS_NAME")

if [ -n "$PID" ]; then
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$MONITORING_URL")
    
    if [ "$RESPONSE" -ne 200 ]; then
        echo "$(date): Server monitoring unavailable (HTTP status: $RESPONSE)" >> "$LOG_FILE"
    fi
    
    if [ ! -f "/tmp/${PROCESS_NAME}_pid" ] || [ "$(cat /tmp/${PROCESS_NAME}_pid)" != "$PID" ]; then
        echo "$PID" > "/tmp/${PROCESS_NAME}_pid"
        echo "$(date): Process $PROCESS_NAME restarted (PID: $PID)" >> "$LOG_FILE"
    fi
fi
