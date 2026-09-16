#!/bin/bash

# ==========================================
#          NETWATCH MASTER CONTROLLER
# ==========================================

set -u

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$PROJECT_DIR/scripts"
LOG_DIR="$PROJECT_DIR/logs"

SYSTEM_MONITOR="$SCRIPT_DIR/system_monitor.sh"
NETWORK_MONITOR="$SCRIPT_DIR/network_monitor.sh"
PORT_MONITOR="$SCRIPT_DIR/port_monitor.sh"

mkdir -p "$LOG_DIR"

# ==========================================
#              FUNCTIONS
# ==========================================

print_header() {
    echo
    echo "=========================================="
    echo "           NETWATCH SYSTEM MONITOR"
    echo "=========================================="
    echo
}

run_monitor() {
    local name="$1"
    local script="$2"

    echo "------------------------------------------"
    echo "           $name"
    echo "------------------------------------------"
    echo

    if [ ! -x "$script" ]; then
        echo "[ERROR] $script not found or not executable"
        return 1
    fi

    "$script"

    if [ $? -eq 0 ]; then
        echo
        echo "[OK] $name completed"
        return 0
    else
        echo
        echo "[ERROR] $name failed"
        return 1
    fi
}

# ==========================================
#              START NETWATCH
# ==========================================

clear

print_header

echo "Project Directory : $PROJECT_DIR"
echo "Script Directory  : $SCRIPT_DIR"
echo "Log Directory     : $LOG_DIR"
echo

echo "Starting monitoring system..."
echo

# ==========================================
#          CHECK REQUIRED SCRIPTS
# ==========================================

echo "[1/4] Checking monitoring scripts..."

REQUIRED_SCRIPTS=(
    "$SYSTEM_MONITOR"
    "$NETWORK_MONITOR"
    "$PORT_MONITOR"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [ ! -f "$script" ]; then
        echo "[ERROR] Missing script: $script"
        exit 1
    fi
done

echo "[OK] All monitoring scripts found"
echo

# ==========================================
#             SYSTEM MONITORING
# ==========================================

SYSTEM_STATUS=0

run_monitor "SYSTEM MONITORING" "$SYSTEM_MONITOR" || SYSTEM_STATUS=1

# ==========================================
#             NETWORK MONITORING
# ==========================================

NETWORK_STATUS=0

run_monitor "NETWORK MONITORING" "$NETWORK_MONITOR" || NETWORK_STATUS=1

# ==========================================
#              PORT MONITORING
# ==========================================

PORT_STATUS=0

run_monitor "PORT MONITORING" "$PORT_MONITOR" || PORT_STATUS=1

# ==========================================
#               FINAL STATUS
# ==========================================

echo
echo "=========================================="
echo "             NETWATCH SUMMARY"
echo "=========================================="

if [ "$SYSTEM_STATUS" -eq 0 ]; then
    echo "System Monitoring  : SUCCESS"
else
    echo "System Monitoring  : FAILED"
fi

if [ "$NETWORK_STATUS" -eq 0 ]; then
    echo "Network Monitoring : SUCCESS"
else
    echo "Network Monitoring : FAILED"
fi

if [ "$PORT_STATUS" -eq 0 ]; then
    echo "Port Monitoring    : SUCCESS"
else
    echo "Port Monitoring    : FAILED"
fi

echo
echo "Monitoring data has been stored in MySQL."
echo "=========================================="
echo

# ==========================================
#          RETURN FINAL EXIT STATUS
# ==========================================

if [ "$SYSTEM_STATUS" -eq 0 ] &&
   [ "$NETWORK_STATUS" -eq 0 ] &&
   [ "$PORT_STATUS" -eq 0 ]; then

    echo "[OK] NETWATCH completed successfully"
    exit 0

else

    echo "[ERROR] NETWATCH completed with errors"
    exit 1

fi

