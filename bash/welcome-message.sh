#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!


###############
# Variables   #
###############
title="Overlord"
USER="$USER"
hostname="$(hostname)"
current_time=$(date +"%A at %I:%M %p")

# Function to set title based on the day of the week
set_title() {
    day=$(date +"%A")
    case $day in
        "Monday") title="Optimist" ;;
        "Tuesday") title="Realist" ;;
        "Wednesday") title="Pessimist" ;;
        # Add more titles for other days of the week if you wish
        *) title="Default Title" ;;
    esac
}

# Set the title based on the day of the week
set_title

###############
# Main        #
###############
cat <<EOF

It is $current_time on $current_day.
Welcome to planet $hostname, "$title $USER!"

EOF

