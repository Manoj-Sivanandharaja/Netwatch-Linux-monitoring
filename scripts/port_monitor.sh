#!/bin/bash

# ==========================================
#        NETWATCH PORT MONITOR
# ==========================================

DB_NAME="netwatch"

echo "===================================="
echo "        NETWATCH PORT MONITOR"
echo "===================================="

echo ""
echo "-------- LISTENING TCP PORTS --------"

TCP_PORTS=$(ss -ltnH | awk '
{
    split($4, addr, ":")
    port = addr[length(addr)]

    if (port ~ /^[0-9]+$/)
        print port
}' | sort -n | uniq)

if [ -z "$TCP_PORTS" ]; then
    echo "No TCP listening ports found"
else
    echo "$TCP_PORTS" | while read -r PORT
    do
        echo "TCP Port       : $PORT"

	mysql netwatch -e "
        INSERT INTO port_events
        (protocol, port, status)
        VALUES
        ('TCP', '$PORT', 'LISTENING');
        " > /dev/null
    done
fi

echo ""
echo "-------- LISTENING UDP PORTS --------"

UDP_PORTS=$(ss -lunH | awk '
{
    split($5, addr, ":")
    port = addr[length(addr)]

    if (port ~ /^[0-9]+$/)
        print port
}' | sort -n | uniq)

if [ -z "$UDP_PORTS" ]; then
    echo "No UDP listening ports found"
else
    echo "$UDP_PORTS" | while read -r PORT
    do
        echo "UDP Port       : $PORT"

	mysql netwatch -e "
        INSERT INTO port_events
        (protocol, port, status)
        VALUES
        ('UDP', '$PORT', 'LISTENING');
        " > /dev/null
    done
fi

echo ""
echo "----------- DATABASE ---------------"

echo "Database        : PORT DATA SAVED"

echo ""
echo "===================================="
