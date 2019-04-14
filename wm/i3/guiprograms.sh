#!/bin/sh
INIT=$(rofi -i -p "Launch" -dmenu -theme ~/.config/rofi/dracula.rasi << EOF
Firefox
Telegram
Skype
EOF
)

case "$INIT" in
    Firefox)
        firefox
        ;;
    Telegram)
        telegram-desktop
        ;;
    Skype)
        skypeforlinux
        ;;
esac
