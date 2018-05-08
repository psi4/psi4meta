#!/bin/bash

# Function to prompt for yes/no from:
# https://gist.github.com/davejamesmiller/1965569
function ask {
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

echo
if ask "Do you accept the Intel End User License Agreement for this Intel OpenMP Runtime Library Redistributable?" Y; then
    exit 0
else
    echo "You must accept the Intel End User License Agreement to install this Intel OpenMP Runtime Library Redistributable"
    exit 1
fi

#echo "Automatically agreeing to the Intel End User License Agreement for this Redistributable"
