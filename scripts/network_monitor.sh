#!/bin/bash
# ==========================================
#        NETWATCH NETWORK MONITOR
# ==========================================

DB_NAME="netwatch"

echo "===================================="
echo "       NETWATCH NETWORK MONITOR"
echo "===================================="

# Detect active network interface
INTERFACE=$(ip route | awk '/default/ {print $5; exit}')

# Get IPv4 address
IP_ADDRESS=$(ip -4 addr show "$INTERFACE" | awk '/inet / {print $2; exit}')

# Get default gateway
GATEWAY=$(ip route | awk '/default/ {print $3; exit}')

echo "Interface       : $INTERFACE"
echo "IP Address      : $IP_ADDRESS"
echo "Gateway         : $GATEWAY"

echo ""
echo "----------- CONNECTIVITY -----------"

# Ping gateway
PING_RESULT=$(ping -c 4 -W 2 "$GATEWAY" 2>&1)

# Gateway status
if echo "$PING_RESULT" | grep -q "0% packet loss"; then
    GATEWAY_STATUS="REACHABLE"
else
    GATEWAY_STATUS="UNREACHABLE"
fi

echo "Gateway         : $GATEWAY_STATUS"

# Packet loss
PACKET_LOSS=$(echo "$PING_RESULT" |
    awk -F', ' '/packet loss/ {print $3}' |
    awk '{print $1}')

# Remove % if present
PACKET_LOSS=${PACKET_LOSS%\%}

echo "Packet Loss     : ${PACKET_LOSS}%"

# Average latency
LATENCY=$(echo "$PING_RESULT" |
    awk -F'/' '/rtt/ {print $5}')

if [ -z "$LATENCY" ]; then
    LATENCY="0"
fi

echo "Latency         : ${LATENCY} ms"

# Internet connectivity
if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    INTERNET_STATUS="CONNECTED"
else
    INTERNET_STATUS="DISCONNECTED"
fi

echo "Internet        : $INTERNET_STATUS"

# DNS resolution
if getent hosts google.com > /dev/null 2>&1; then
    DNS_STATUS="WORKING"
else
    DNS_STATUS="FAILED"
fi

echo "DNS Resolution  : $DNS_STATUS"

echo ""
echo "----------- DATABASE ---------------"

# Insert monitoring data into MySQL
mysql netwatch -e "
INSERT INTO network_metrics
(interface_name, ip_address, gateway, packet_loss, latency_ms,
 internet_status, dns_status)
VALUES
('$INTERFACE',
 '$IP_ADDRESS',
 '$GATEWAY',
 '$PACKET_LOSS',
 '$LATENCY',
 '$INTERNET_STATUS',
 '$DNS_STATUS');
"

if [ $? -eq 0 ]; then
    echo "Database        : RECORD SAVED"
else
    echo "Database        : INSERT FAILED"
fi

echo "===================================="
