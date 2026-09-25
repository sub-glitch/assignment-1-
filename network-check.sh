#!/bin/bash
DATE=$(date)

exec > >(tee -a logs/logs.log)

echo "===================="
echo "[$DATE] Network Check"
echo "===================="


HOST=$1
PORT=$2
RESOLVED_ADDRESS=$(getent ahosts "$HOST" | awk 'NR==1 {print  $1}')

if [ -z "$HOST" ]
then
    echo "Usage: $0 <host> [port]"
    exit 2
fi

if [ -z "$RESOLVED_ADDRESS" ]
then
    echo "Unable to resolve host: $HOST"
    exit 1
fi

echo "Resolved address: $RESOLVED_ADDRESS" 

echo "Connectivity check:"
if ping -c 4 "$HOST" > /dev/null 2>&1
then
    echo "Ping: successful"
else
    echo "Ping: failed"
fi

echo
echo "Network interfaces:"
ip -br addr

if [ -n "$PORT" ]
then
    
    if [[ ! "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]
    then
        echo "Invalid port. Port must be between 1 and 65535."
        exit 2
    fi

    echo
    echo "TCP connectivity check:" 

    if nc -z -w 2 "$HOST" "$PORT" > /dev/null 2>&1
    then
        echo "TCP port $PORT: reachable"
    else
        echo "TCP port $PORT: unreachable"
        exit 1
    fi

fi

exit 0

