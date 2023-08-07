#!/bin/bash

# Function to check if the user has root privilege
check_root_privilege() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: This script requires root privilege. Please run it with sudo or as root."
        exit 1
    fi
}

# Function to check if a command has failed and display an error message
check_command_status() {
    if [ $? -ne 0 ]; then
        echo "Error: Failed to retrieve data. Please make sure all required commands are installed and functioning properly."
        exit 1
    fi
}

# Function to get system description
get_system_description() {
    system_desc=$(dmidecode -t system)
    echo "System Description:"
    echo "   Computer Manufacturer: $(echo "$system_desc" | grep "Manufacturer:" | sed 's/^[ \t]*//')"
    echo "   Computer Model: $(echo "$system_desc" | grep "Product Name:" | sed 's/^[ \t]*//')"
    echo "   Computer Serial Number: $(echo "$system_desc" | grep "Serial Number:" | sed 's/^[ \t]*//')"
}

# Function to get CPU information
get_cpu_info() {
    cpu_info=$(lshw -C cpu 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "CPU Information: Data not available."
    else
        echo "CPU Information:"
        echo "   CPU Manufacturer and Model: $(echo "$cpu_info" | grep "product:" | sed 's/^[ \t]*//')"
        echo "   CPU Architecture: $(echo "$cpu_info" | grep "width:" | sed 's/^[ \t]*//')"
        echo "   CPU Core Count: $(echo "$cpu_info" | grep "cores" | awk '{print $2}')"
        echo "   CPU Maximum Speed: $(echo "$cpu_info" | grep "capacity:" | sed 's/^[ \t]*//')"
        echo "   Sizes of Caches:"
        echo "      L1: $(echo "$cpu_info" | grep "size: 32" | sed 's/^[ \t]*//')"
        echo "      L2: $(echo "$cpu_info" | grep "size: 256" | sed 's/^[ \t]*//')"
        echo "      L3: $(echo "$cpu_info" | grep "size: 4096" | sed 's/^[ \t]*//')"
    fi
}

# Function to get operating system information
get_os_info() {
    os_distro=$(lsb_release -a 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Operating System Information: Data not available."
    else
        echo "Operating System Information:"
        echo "   Linux Distro: $(echo "$os_distro" | grep "Distributor ID:" | awk '{print $3}')"
        echo "   Distro Version: $(echo "$os_distro" | grep "Release:" | awk '{print $2}')"
    fi
}

# Check if the user has root privilege
check_root_privilege

# Generate the report
echo
get_system_description
echo "======================================="
get_cpu_info
echo "======================================="
get_os_info
