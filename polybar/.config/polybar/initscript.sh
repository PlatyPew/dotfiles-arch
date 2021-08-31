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
        betterlockscreen --lock dimblur --dim 10 --blur 0.5
        ;;
    Suspend)
        betterlockscreen --lock dimblur --dim 10 --blur 0.5 & systemctl suspend
        ;;
    Reboot)
        reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
