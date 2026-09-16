#!/bin/bash
# ==========================================
#        NETWATCH SYSTEM MONITOR
# ==========================================

DB_NAME="netwatch"

echo "===================================="
echo "        NETWATCH SYSTEM MONITOR"
echo "===================================="

# Basic system information
HOSTNAME=$(hostname)
CURRENT_USER="$USER"

echo "Hostname        : $HOSTNAME"
echo "User            : $CURRENT_USER"

# Uptime in seconds
UPTIME_SECONDS=$(awk '{print int($1)}' /proc/uptime)

UPTIME_HUMAN=$(uptime -p)

echo "Uptime          : $UPTIME_HUMAN"

echo ""
echo "----------- MEMORY ----------------"

# Memory usage percentage
MEMORY_USAGE=$(free | awk '/Mem:/ {
    printf "%.2f", ($3/$2)*100
}')

echo "Memory Usage    : ${MEMORY_USAGE}%"

echo ""
echo "----------- DISK ------------------"

# Root filesystem disk usage
DISK_USAGE=$(df / | awk 'NR==2 {
    gsub("%","",$5)
    print $5
}')

echo "Disk Usage      : ${DISK_USAGE}%"

echo ""
echo "----------- CPU -------------------"

# CPU usage using /proc/stat
read cpu user nice system idle iowait irq softirq steal guest guest_nice \
    < /proc/stat

TOTAL1=$((user + nice + system + idle + iowait + irq + softirq + steal))
IDLE1=$((idle + iowait))

sleep 1

read cpu user nice system idle iowait irq softirq steal guest guest_nice \
    < /proc/stat

TOTAL2=$((user + nice + system + idle + iowait + irq + softirq + steal))
IDLE2=$((idle + iowait))

TOTAL_DIFF=$((TOTAL2 - TOTAL1))
IDLE_DIFF=$((IDLE2 - IDLE1))

if [ "$TOTAL_DIFF" -gt 0 ]; then
    CPU_USAGE=$(awk "BEGIN {printf \"%.2f\", (1 - $IDLE_DIFF/$TOTAL_DIFF)*100}")
else
    CPU_USAGE="0.00"
fi

echo "CPU Usage       : ${CPU_USAGE}%"

echo ""
echo "----------- DATABASE ---------------"

# Insert system metrics into MySQL
mysql netwatch -e "
INSERT INTO system_metrics
(hostname, username, cpu_usage, memory_usage, disk_usage, uptime_seconds)
VALUES
('$HOSTNAME',
 '$CURRENT_USER',
 '$CPU_USAGE',
 '$MEMORY_USAGE',
 '$DISK_USAGE',
 '$UPTIME_SECONDS');
"

if [ $? -eq 0 ]; then
    echo "Database        : RECORD SAVED"
else
    echo "Database        : INSERT FAILED"
fi

echo "===================================="
