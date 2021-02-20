#!/bin/sh
INIT=$(rofi -i -p "Init" -dmenu -theme ~/.config/rofi/dracula.rasi << EOF
Lock
Suspend
Hibernate
Reboot
Shutdown
EOF
)

case "$INIT" in
    Lock)
        multilockscreen --off 300 --lock dimblur --dim 10 --blur 0.5
        ;;
    Suspend)
        systemctl suspend
        ;;
    Hibernate)
        systemctl hibernate
        ;;
    Reboot)
        reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
