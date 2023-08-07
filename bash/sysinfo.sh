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
        num_cpus=$(grep -c "^processor" /proc/cpuinfo)
        for (( i = 0; i < num_cpus; i++ )); do
            echo "   CPU $((i+1)):"
            echo "      CPU Manufacturer and Model: $(echo "$cpu_info" | awk -v i="$i" '/product:/{c++}c==(i+1){print $2 " " $3}')"
            echo "      CPU Architecture: $(echo "$cpu_info" | awk -v i="$i" '/width:/{c++}c==(i+1){print $2}')"
            echo "      CPU Core Count: $(echo "$cpu_info" | awk -v i="$i" '/cores:/{c++}c==(i+1){print $2}')"
            echo "      CPU Maximum Speed: $(echo "$cpu_info" | awk -v i="$i" '/capacity:/{c++}c==(i+1){print $2}')"
            echo "      Sizes of Caches:"
            echo "         L1: $(echo "$cpu_info" | awk -v i="$i" '/size: 32K/{c++}c==(i+1){print $2}')"
            echo "         L2: $(echo "$cpu_info" | awk -v i="$i" '/size: 256K/{c++}c==(i+1){print $2}')"
            echo "         L3: $(echo "$cpu_info" | awk -v i="$i" '/size: 4096K/{c++}c==(i+1){print $2}')"
        done
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

# Function to get RAM information
get_ram_info() {
    ram_info=$(lshw -C memory 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "RAM Information: Data not available."
    else
        echo "RAM Information:"
        total_ram=$(echo "$ram_info" | grep "size:" | awk '{print $2}' | awk '{sum+=$1} END{print sum}')
        echo "   Total Installed RAM: $total_ram"
        echo "   DIMM Details:"
        echo "   +-------------+---------------------------------+--------------+-----------------+-------------------------+"
        echo "   | Manufacturer| Model/Product Name              | Size         | Speed           | Physical Location       |"
        echo "   +-------------+---------------------------------+--------------+-----------------+-------------------------+"
        echo "$ram_info" | awk '/memory/{gsub("size:", "", $2); gsub("clock:", "", $3); gsub("bank:", "", $4); print "   | " $2 "      | " $3 "       | " $1 " | " $4 " | " $5 " |"}'
        echo "   +-------------+---------------------------------+--------------+-----------------+-------------------------+"
    fi
}

# Function to get disk storage information
get_disk_info() {
    disk_info=$(lsblk -o NAME,MODEL,SIZE,MOUNTPOINT,FSTYPE 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Disk Storage Information: Data not available."
    else
        echo "Disk Storage Information:"
        echo "   +------+-----------------------+-----------+------------------------+------------------------+"
        echo "   | Drive| Model                 | Size      | Partition Number       | Filesystem Size        |"
        echo "   +------+-----------------------+-----------+------------------------+------------------------+"
        echo "$disk_info" | awk '/disk/{print "   | " $1 " | " $2 " | " $3 " | " $4 " | " $5 " |"}'
        echo "   +------+-----------------------+-----------+------------------------+------------------------+"
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
echo "======================================="
get_ram_info
echo "======================================="
get_disk_info
