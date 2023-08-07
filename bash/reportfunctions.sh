#!/bin/bash

# Function to save error message with timestamp to the logfile
errormessage() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - ERROR: $1" >> /var/log/systeminfo.log
}

# Function for CPU report
cpureport() {
    echo "CPU Information:"
    echo "   CPU Manufacturer and Model: $(lshw -C cpu | awk '/product:/{print $2, $3}')"
    echo "   CPU Architecture: $(lshw -C cpu | awk '/width:/{print $2}')"
    echo "   CPU Core Count: $(lshw -C cpu | awk '/cores:/{print $2}')"
    echo "   CPU Maximum Speed: $(lshw -C cpu | awk '/capacity:/{print $2}')"
    echo "   Sizes of Caches:"
    echo "      L1: $(lshw -C cpu | awk '/size: 32K/{print $2}')"
    echo "      L2: $(lshw -C cpu | awk '/size: 256K/{print $2}')"
    echo "      L3: $(lshw -C cpu | awk '/size: 4096K/{print $2}')"
}

# Function for computer report
computerreport() {
    echo "System Description:"
    echo "   Computer Manufacturer: $(dmidecode -t system | awk '/Manufacturer:/{print $2}')"
    echo "   Computer Model: $(dmidecode -t system | awk '/Product Name:/{print $3}')"
    echo "   Computer Serial Number: $(dmidecode -t system | awk '/Serial Number:/{print $3}')"
}

# Function for OS report
osreport() {
    echo "Operating System Information:"
    echo "   Linux Distro: $(lsb_release -a 2>/dev/null | awk '/Distributor ID:/{print $3}')"
    echo "   Distro Version: $(lsb_release -a 2>/dev/null | awk '/Release:/{print $2}')"
}

# Function for RAM report
ramreport() {
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

# Function for video report
videoreport() {
    echo "Video Information:"
    echo "   Video Card/Chipset Manufacturer: $(lshw -C display | awk '/vendor:/{print $2}')"
    echo "   Video Card/Chipset Description or Model: $(lshw -C display | awk '/product:/{print $2}')"
}

# Function for disk report
diskreport() {
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

# Function for network report
networkreport() {
    network_info=$(lshw -C network 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Network Information: Data not available."
    else
        echo "Network Information:"
        echo "   +------+-----------------------+------------+------------------------+------------------------+"
        echo "   | Interface | Model/Description  | Link State | Speed                  | IP Addresses           |"
        echo "   +------+-----------------------+------------+------------------------+------------------------+"
        echo "$network_info" | awk '/network/{print "   | " $2 " | " $3 " | " $4 " | " $5 " | " $9 " |"}'
        echo "   +------+-----------------------+------------+------------------------+------------------------+"
    fi
}
