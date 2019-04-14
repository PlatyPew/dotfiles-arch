#!/bin/sh
INIT=$(rofi -i -p "Init" -dmenu -theme ~/.config/rofi/dracula.rasi << EOF
Lock
Suspend
Reboot
Shutdown
EOF
)

case "$INIT" in
    Lock)
        betterlockscreen -l dimblur
        ;;
    Suspend)
        betterlockscreen -s dimblur
        ;;
    Reboot)
        reboot
        ;;
    Shutdown)
        shutdown now
        ;;
esac
