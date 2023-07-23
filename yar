#!/bin/bash
expected_status='Country: Switzerland'
torrent_client=transmission-gtk

while :
do
    nord_status=$(echo $(nordvpn status | grep Country))
    if [ "$nord_status" == "$expected_status" ]; then
        # Open torrent client if not already open
        pgrep $torrent_client > /dev/null || $torrent_client &
        sleep 5
    else
        killall -q $torrent_client
        nordvpn d && nordvpn c Switzerland && nord_status=$(echo $(nordvpn status | grep Country))
        if [ "$nord_status" != "$expected_status" ]; then
            echo "$(date '+%H:%M:%S %d-%m-%Y') | Connection unsuccessful. Trying again in 5 minutes."
            sleep 300
        else
            $torrent_client &
        fi
    fi
done
