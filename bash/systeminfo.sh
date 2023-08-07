#!/bin/bash

# Source the function library file
source reportfunctions.sh

# Function to print help message
display_help() {
    echo "Usage: $0 [OPTION]"
    echo "Generate system information report."
    echo
    echo "Options:"
    echo "  -h           Display this help and exit."
    echo "  -v           Run script in verbose mode (show errors to the user instead of logging them)."
    echo "  -system      Generate computer, OS, CPU, RAM, and video reports."
    echo "  -disk        Generate disk report."
    echo "  -network     Generate network report."
    echo
}

# Function to print errors to stderr or log them
errormessage() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local message="$timestamp - ERROR: $1"
    if [ "$VERBOSE" = true ]; then
        echo "$message" >&2
    else
        echo "$message" >> /var/log/systeminfo.log
    fi
}

# Check if the user has root privilege
check_root_privilege() {
    if [[ $EUID -ne 0 ]]; then
        errormessage "This script requires root privilege. Please run it with sudo or as root."
        exit 1
    fi
}

# Handle command line options
while getopts ":hvsystemdisknetwork" option; do
    case "$option" in
        h)
            display_help
            exit 0
            ;;
        v)
            VERBOSE=true
            ;;
        system)
            REPORT_SYSTEM=true
            ;;
        disk)
            REPORT_DISK=true
            ;;
        network)
            REPORT_NETWORK=true
            ;;
        \?)
            errormessage "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            errormessage "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

# Check if user is root
check_root_privilege

# Generate full system report if no specific options provided
if [ $# -eq 0 ]; then
    REPORT_SYSTEM=true
    REPORT_DISK=true
    REPORT_NETWORK=true
fi

# Generate reports based on command line options
if [ "$REPORT_SYSTEM" = true ]; then
    echo "System Report:"
    echo "==============="
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
fi

if [ "$REPORT_DISK" = true ]; then
    echo
    echo "Disk Storage Report:"
    echo "===================="
    diskreport
fi

if [ "$REPORT_NETWORK" = true ]; then
    echo
    echo "Network Report:"
    echo "==============="
    networkreport
fi
