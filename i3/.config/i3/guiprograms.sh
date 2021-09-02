#!/bin/env zsh
INIT=$(rofi -i -p "Launch" -dmenu -theme ~/.config/rofi/dracula.rasi << EOF
Brave
Discord
Steam
Telegram
EOF
)

case "$INIT" in
    Brave)
        brave
        ;;
    Discord)
        PULSE_PROP="filter.want=echo-cancel" discord
        ;;
    Steam)
        steam
        ;;
    Telegram)
        telegram-desktop
        ;;
esac
