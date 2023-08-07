#!/bin/bash

# Function to display the fully-qualified domain name (FQDN)
get_fqdn() {
    fqdn=$(hostname)
    echo "FQDN: $fqdn"
}

# Function to display host information
get_host_info() {
    echo "Host Information:"
    hostnamectl
}

# Function to display IP addresses (excluding 127.0.0.1)
get_ip_addresses() {
    ip_addresses=$(hostname -I | grep -v '^127\.' | tr -s ' ' '\n')
    echo "IP Addresses:"
    echo "$ip_addresses"
}

# Function to display root filesystem status
get_root_fs_status() {
    echo "Root Filesystem Status:"
    df -h / | tail -1
}

# Main script
get_fqdn
get_host_info
get_ip_addresses
get_root_fs_status
