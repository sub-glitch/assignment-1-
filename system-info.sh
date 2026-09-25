#!/bin/bash
HOSTNAME=$(hostname)
USERNAME=$(whoami)
DATE=$(date)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
WORKING_DIR=$(pwd)
MEMORY_TOTAL=$(free -m | awk ' $1 == "Mem:" {print $2}')
MEMORY_USAGE=$(free -m | awk ' $1 == "Mem:" {print int(($3 / $2) * 100)} ')
CPU_MODEL=$(lscpu | grep "Model name:" | sed 's/Model name:\s*//')
CPU_CORES=$(lscpu | grep "^CPU(s):" | sed 's/CPU(s):\s*//')

echo
echo "Current User: $USERNAME"


echo
echo "Hostname: $HOSTNAME"


echo
echo "Date: $DATE"


echo
echo "Kernel release: $KERNEL" 

echo
echo "Uptime: $UPTIME"

echo
echo "Working Directory: $WORKING_DIR"

echo
echo "Memory Total: $MEMORY_TOTAL MB"
echo "Memory Usage: $MEMORY_USAGE %"

if [ -f /etc/os-release ]; then
    OS=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
else
    OS=$(uname -o)
fi

echo
echo "Operating System: $OS"

 
echo "CPU Information:\t$CPU_MODEL ($CPU_CORES Cores)"








